class Request < ActiveRecord::Base
	# 0 = Sunday, 1 = Monday, and so on
	@@standard_times_by_day = [8..16,8..16,8..16,8..16,8..16,8..16,8..16]

	attr_accessor :posted_delivery_date, :posted_delivery_time, :skip_delivery_validation

	belongs_to :user
	belongs_to :driver, class_name: 'User'
	has_many :notifications

	validates :user_id, presence: true

	def self.delivery_time_available?(time)
		within_standard_times?(time) and fits_with_other_delivery_times?(time, all)
	end

	def self.available_delivery_times(from_time=Time.now)
		time_format = '%m/%d/%Y'
		available_times = {}
		available_times[from_time.strftime(time_format)] = @@standard_times_by_day[from_time.wday].to_a.select {|time| time >= from_time.hour + 8}
		29.times do |i|
			time = from_time + (i+1).days
			available_times[time.strftime(time_format)] = @@standard_times_by_day[time.wday].to_a
		end
		self.where(completion_time: nil, delivery_time:(from_time.to_date..(from_time+30.days).to_date)).select(:delivery_time).each do |request|
			delivery_time = request.delivery_time
			date_string = delivery_time.strftime(time_format)
			hour1 = delivery_time.hour
			hour2 = if delivery_time.min > 10 then delivery_time.hour + 1 else nil end
			if available_times[date_string]
				available_times[date_string].delete(hour1)
				if hour2 then available_times[date_string].delete(hour2) end
			end
		end
		available_times
	end


	private

	def normalize_delivery_time
		if not (self.posted_delivery_time.blank? or self.posted_delivery_date.blank?) then
			self.delivery_time = Date.strptime(self.posted_delivery_date, '%m/%d/%Y') + self.posted_delivery_time.to_i.hours
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
		return false if time < Time.now + 8.hours
		# return true
		return time.hour.in? @@standard_times_by_day[time.wday]
	end

	def self.fits_with_other_delivery_times?(time, requests)
		not requests.where(completion_time: nil, delivery_time: (time - 1.hour)..(time + 1.hour)).exists?
	end
end