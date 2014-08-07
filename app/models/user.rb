class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  phony_normalize :phone_number, default_country_code: 'US'
  before_validation :normalize_city, :normalize_state

  validates :first_name, :last_name, :address_line_1, :city, :state, :zip, :phone_number, presence: true
  validates :city, format: { with: /\ABoulder\z/, message: 'must be Boulder.' }
  validates :state, format: { with: /\ACO\z/, message: 'must be CO.' }
  validates :zip, inclusion: { in: [80301, 80303], message: 'must be 80301 or 80303.' }
  validates :phone_number, :phony_plausible => true


  


  protected

  def normalize_city
  	self.city = self.city.strip.capitalize unless self.city.blank?
  end

  def normalize_state
  	self.state = self.state.strip.upcase unless self.state.blank?
  end

	# user m props
	# email
	# password

	# first_name
	# last_name
	# address_line_1
	# address_line_2
	# city
	# state
	# zip
	# special_instructions
	# phone_number

	# billing:
	# name on cc
	# ccn
	# exp month
	# exp year
	# code



end
