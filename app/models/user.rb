class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :exp_month, :exp_year, :cc_name, :cc_number, :cc_cvc

  has_many :storage_items
  has_many :packing_supplies_requests
  has_many :delivery_requests
  has_many :pickup_requests
  has_many :notifications
  has_many :unavailable_times
  has_many :completed_storage_items, class_name: 'StorageItem', foreign_key: 'driver_id'
  has_many :completed_packing_supplies_requests, class_name: 'PackingSuppliesRequest', foreign_key: 'driver_id'
  has_many :completed_delivery_requests, class_name: 'DeliveryRequest', foreign_key: 'driver_id'
  has_many :completed_pickup_requests, class_name: 'PickupRequest', foreign_key: 'driver_id'

  phony_normalize :phone_number, default_country_code: 'US'
  before_validation :normalize_city, :normalize_state, :make_password_nil_if_blank, :send_card_info_to_stripe

  validates :first_name, :last_name, presence: true
  validates :phone_number, :phony_plausible => true
  validates :city, format: { with: /\ABoulder\z/, message: 'must be Boulder.' }, allow_nil: true
  validates :state, format: { with: /\ACO\z/, message: 'must be CO.' }, allow_nil: true
  validates :zip, inclusion: {in: [80301, 80302, 80303, 80304, 80305, 80306, 80307, 80308, 80309, 80314, 80321, 80322, 80323, 80328, 80329], message: 'must be a boulder zip code' }, allow_nil: true
  validates :exp_month, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12}, allow_nil: true
  validates :exp_year, numericality: {only_integer: true, greater_than_or_equal_to: 2014, less_than_or_equal_to: 2035}, allow_nil: true

  after_create :create_stripe_customer

  def boxes_at_home
    PackingSuppliesRequest.where(user_id: self.id).where.not(completion_time: nil).sum(:box_quantity) - PickupRequest.where(user_id: self.id).where.not(completion_time: nil).sum(:box_quantity)
  end

  def ready?
    return true if self.stripe_user.cards.first and self.address_line_1 and self.city and self.state and self.zip and self.phone_number and self.terms_of_service_accepted
    return false
  end

  def stripe_user
    Stripe::Customer.retrieve self.stripe_customer_identifier
  end

  protected

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
    self.save
  end

  def send_card_info_to_stripe
    if not (self.exp_month.blank? or self.exp_year.blank? or self.cc_number.blank? or self.cc_name.blank? or self.cc_cvc.blank? or self.stripe_customer_identifier.blank?)
      customer = self.stripe_user
      customer.cards.create(card:{
        number: self.cc_number,
        exp_month: self.exp_month.to_i,
        exp_year: self.exp_year.to_i,
        cvc: self.cc_cvc,
        name: self.cc_name,
      })
      begin
        unless self.promo_code.blank?
          customer.coupon = self.promo_code
          customer.save
        end
      rescue Stripe::InvalidRequestError
        errors.add(:promo_code, 'is invalid.')
        self.promo_code = nil
      end
    else
      self.promo_code = nil
    end
  end
end
