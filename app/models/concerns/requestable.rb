module Requestable
	extend ActiveSupport::Concern

	included do
		belongs_to :user
		belongs_to :driver, class_name: 'User'
		validates :user_id, :delivery_time, presence: true
	end

	def delivery_time_available?(time)
		within_standard_times?(time) and fits_with_other_delivery_times?(time)
	end

	private

	def within_standard_times?(time)
		if time.saturday? or time.sunday?
			return time.in? 12..19
		elsif time.monday? or time.wednesday? or time.friday?
			return time.in? 8..19
		elsif time.tuesday? or time.thursday?
			return time.in? 19..22
		end
	end

	def fits_with_other_delivery_times?(time)
		
	end
end