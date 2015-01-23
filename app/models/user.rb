class User < ActiveRecord::Base
  include Textable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :exp_month, :exp_year, :cc_name, :cc_number, :cc_cvc, :send_reset_password_welcome_email

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
  validates :zip, inclusion: {in: [80002, 80003, 80004, 80005, 80007, 80020, 80021, 80022, 80026, 80027, 80030, 80031, 80033, 80045, 80202, 80203, 80204, 80205, 80206, 80207, 80209, 80210, 80211, 80212, 80214, 80215, 80216, 80218, 80219, 80220, 80221, 80222, 80223, 80224, 80226, 80227, 80228, 80229, 80230, 80231, 80232, 80233, 80234, 80235, 80236, 80237, 80238, 80239, 80241, 80246, 80247, 80249, 80260, 80264, 80290, 80293, 80294, 80301, 80302, 80303, 80304, 80305, 80310, 80401, 80403, 80419, 80501, 80503, 80504, 80516], message: 'is not currently in our service area.' }, allow_nil: true
  validates :exp_month, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12}, allow_blank: true
  validates :exp_year, numericality: {only_integer: true, greater_than_or_equal_to: 2014, less_than_or_equal_to: 2035}, allow_blank: true

  before_create :create_stripe_customer
  after_create :send_admin_signup_text, :send_welcome_email, :mark_subscriber_as_converted
  after_save :send_card_info_to_stripe
  after_commit :identify_customerio

  def send_welcome_email
    if Rails.env.production?
      if self.send_reset_password_welcome_email == true or self.send_reset_password_welcome_email == '1'
        # UserMailer.delay.reset_password_welcome_email(self.id)
      else
        # UserMailer.delay.welcome_email(self.id)
      end
    end
    true
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
      phone_number: self.phone_number,
      admin: self.admin,
      stripe_customer_identifier: self.stripe_customer_identifier,
      promo_code: self.promo_code,
      referrer: self.referrer,
      terms_of_service_accepted: self.terms_of_service_accepted,
      name: self.name,
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
      field :send_reset_password_welcome_email, :boolean
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
