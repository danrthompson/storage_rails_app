class Request < ActiveRecord::Base
	@@packing_items = %w(bubble file_box poster_tube)

	attr_accessor :posted_delivery_date, :posted_delivery_time

	belongs_to :user
	belongs_to :driver, class_name: 'User'

	before_validation :normalize_delivery_time

	validates :user_id, :delivery_time, presence: true
	validate :delivery_time_is_available

	def self.delivery_time_available?(time)
		within_standard_times?(time) and fits_with_other_delivery_times?(time, all)
	end

	private

	def normalize_delivery_time
		if self.posted_delivery_time and self.posted_delivery_date then
			self.delivery_time = Date.strptime(self.posted_delivery_date, '%a %b %d %Y') + self.posted_delivery_time.to_i.hours
			self.posted_delivery_time = nil
			self.posted_delivery_date = nil
		end
	end

	def delivery_time_is_available
		if self.delivery_time then
			errors.add(:delivery_time, 'is unavailable') unless Request.within_standard_times?(self.delivery_time) and Request.fits_with_other_delivery_times?(self.delivery_time, Request.where.not(id: self.id))
		end
	end

	def self.within_standard_times?(time)
		if time.saturday? or time.sunday?
			return time.hour.in? 12..19
		elsif time.monday? or time.wednesday? or time.friday?
			return time.hour.in? 8..19
		elsif time.tuesday? or time.thursday?
			return time.hour.in? 19..22
		end
	end

	def self.fits_with_other_delivery_times?(time, requests)
		not requests.where(completion_time: nil, delivery_time: (time - 1.hour)..(time + 1.hour)).exists?
	end
end