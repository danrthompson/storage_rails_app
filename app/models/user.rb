class User < ActiveRecord::Base
  include Textable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :exp_month, :exp_year, :cc_name, :cc_number, :cc_cvc

  has_many :storage_items, dependent: :destroy
  has_many :packing_supplies_requests, dependent: :destroy
  has_many :delivery_requests, dependent: :destroy
  has_many :pickup_requests, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :unavailable_times
  has_many :completed_storage_items, class_name: 'StorageItem', foreign_key: 'driver_id'
  has_many :completed_packing_supplies_requests, class_name: 'PackingSuppliesRequest', foreign_key: 'driver_id'
  has_many :completed_delivery_requests, class_name: 'DeliveryRequest', foreign_key: 'driver_id'
  has_many :completed_pickup_requests, class_name: 'PickupRequest', foreign_key: 'driver_id'
  has_paper_trail

  phony_normalize :phone_number, default_country_code: 'US'
  before_validation :normalize_city, :normalize_state, :make_password_nil_if_blank

  validates :name, :phone_number, presence: true
  validates_plausible_phone :phone_number
  validates :state, format: { with: /\ACO\z/, message: 'must be CO.' }, allow_nil: true
  validates :zip, inclusion: {in: [80001,80002,80003,80004,80005,80006,80007,80010,80011,80012,80013,80014,80015,80016,80017,80018,80019,80021,80022,80024,80025,80026,80027,80028,80030,80031,80033,80034,80035,80036,80037,80040,80041,80042,80044,80045,80046,80047,80101,80102,80103,80104,80105,80107,80108,80109,80110,80111,80112,80113,80116,80117,80118,80120,80121,80122,80123,80124,80125,80126,80127,80128,80129,80130,80131,80134,80135,80136,80137,80138,80150,80151,80155,80160,80161,80162,80163,80165,80166,80214,80215,80221,80225,80226,80227,80228,80229,80232,80233,80234,80235,80241,80247,80260,80301,80302,80303,80304,80305,80306,80307,80308,80309,80310,80314,80321,80322,80323,80328,80329,80401,80402,80403,80419,80422,80425,80427,80433,80436,80437,80438,80439,80442,80444,80446,80447,80451,80452,80453,80454,80455,80457,80459,80465,80466,80468,80470,80471,80474,80476,80478,80481,80482,80501,80502,80503,80504,80510,80514,80516,80520,80530,80533,80534,80540,80542,80543,80544,80546,80550,80551,80601,80602,80603,80610,80611,80612,80614,80615,80620,80621,80622,80623,80624,80631,80632,80633,80634,80638,80639,80640,80642,80643,80644,80645,80646,80648,80650,80651,80652,80729,80732,80742,80754,80830,80835], message: 'is not currently in our service area.' }, allow_nil: true
  validates :exp_month, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12}, allow_blank: true
  validates :exp_year, numericality: {only_integer: true, greater_than_or_equal_to: 2014, less_than_or_equal_to: 2035}, allow_blank: true

  before_create :create_stripe_customer
  after_create :send_admin_signup_text, :mark_subscriber_as_converted
  after_save :send_card_info_to_stripe
  after_commit :identify_customerio

  def subscription_price
    base_price = 0.0
    duration_discounted_price = 0.0

    self.storage_items.where(left_storage_at: nil).where.not(entered_storage_at: nil).each do |item|
      item_price = item.discounted_price
      base_price += item_price
      duration_discounted_price += item_price * (1.0 - item.calculate_duration_discount)
    end

    volume_discount = StorageItem.calculate_volume_discount(base_price)

    duration_discounted_price * (1.0 - volume_discount)
  end

  def update_subscription_price(create_invoice=false, price=self.subscription_price)
    stripe_user = self.stripe_user
    if stripe_user.subscriptions.first
      subscription = stripe_user.subscriptions.first
      subscription.quantity = (price * 100).to_i
      subscription.save
      if create_invoice
        begin
          Stripe::Invoice.create(customer: self.stripe_user.id)
        rescue Stripe::InvalidRequestError
        end
      end
    else
      stripe_user.subscriptions.create(plan: 'plan_1', quantity: (price * 100).to_i)
    end
  end

  def mark_subscriber_as_converted
    subscriber = Subscriber.find_by_email(self.email)
    subscriber.identify_customerio if subscriber
  end

  def boxes_at_home
    PackingSuppliesRequest.where(user_id: self.id).where.not(completion_time: nil).sum(:box_quantity) - PickupRequest.where(user_id: self.id).where.not(completion_time: nil).sum(:box_quantity)
  end

  def ready?
    return true if self.stripe_user and self.stripe_user.cards and self.stripe_user.cards.first and self.address_line_1 and self.city and self.state and self.zip and self.phone_number and self.terms_of_service_accepted
    return false
  end

  def stripe_user
    if self.stripe_customer_identifier
      Stripe::Customer.retrieve self.stripe_customer_identifier
    else
      nil
    end
  end

  def add_readiness_errors
    val_hash = {
      'Credit card cannot be blank.' => self.stripe_user.cards.first,
      'Address cannot be blank.' => self.address_line_1,
      'City cannot be blank.' => self.city,
      'State cannot be blank.' => self.state,
      'ZIP code cannot be blank.' => self.zip,
      'Phone number cannot be blank.' => self.phone_number,
      'You must accept the Terms of Service.' => self.terms_of_service_accepted
    }

    if val_hash.values.any? {|val| val.blank?}
      val_hash.each do |key, val|
        if val.blank?
          errors.add(:user, key)
        end
      end
    end
  end

  def identify_customerio
    $customerio.identify(
      id: self.id,
      email: self.email,
      created_at: self.created_at.to_i,
      address_line_1: self.address_line_1,
      address_line_2: self.address_line_2,
      city: self.city,
      state: self.state,
      zip: self.zip,
      special_instructions: self.special_instructions,
      phone_number: self.phone_number,
      admin: self.admin,
      stripe_customer_identifier: self.stripe_customer_identifier,
      promo_code: self.promo_code,
      referrer: self.referrer,
      terms_of_service_accepted: self.terms_of_service_accepted,
      name: self.name,
      first_name: self.name.strip[/^[^\s]*/].capitalize,
      finished_signup_flow: self.ready?,
      tire_customer: self.tire_customer,
      newsletter_subscriber: false,
    )
  end

  rails_admin do
    list do
      field :name
      field :email
      field :phone_number
      field :id
      field :stripe_customer_identifier
      field :created_at
    end
    create do
      include_all_fields
      field :exp_month, :integer
      field :exp_year, :integer
      field :cc_name, :string
      field :cc_number, :string
      field :cc_cvc, :string
    end
  end

  protected

  def send_admin_signup_text
    if Rails.env.production?
      User.send_admin_text('You have a new user signup: ' + self.name + ". Email: " + self.email)
    end
  end

  def normalize_city
  	self.city = self.city.strip.capitalize unless self.city.blank?
  end

  def normalize_state
  	self.state = self.state.strip.upcase unless self.state.blank?
  end

  def make_password_nil_if_blank
    self.password = nil if self.password.blank?
    self.password_confirmation = nil if self.password_confirmation.blank?
  end

  def create_stripe_customer
    customer = Stripe::Customer.create(
      email: self.email,
      metadata: {id: self.id}
    )
    self.stripe_customer_identifier = customer.id
  end

  def send_card_info_to_stripe
    customer = self.stripe_user
    begin
      unless self.promo_code.blank?
        self.update_column('promo_code', self.promo_code.upcase)
        customer.coupon = self.promo_code
        customer.save
      end
    rescue Stripe::InvalidRequestError
      errors.add(:promo_code, 'is invalid.')
      self.update_column('promo_code', nil)
    end
    unless self.exp_month.blank? or self.exp_year.blank? or self.cc_number.blank? or self.cc_name.blank? or self.cc_cvc.blank? or self.stripe_customer_identifier.blank?
      customer.cards.create(card:{
        number: self.cc_number,
        exp_month: self.exp_month.to_i,
        exp_year: self.exp_year.to_i,
        cvc: self.cc_cvc,
        name: self.cc_name,
      })
    end
  end
end




