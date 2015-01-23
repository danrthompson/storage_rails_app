class Request < ActiveRecord::Base
	# 0 = Sunday, 1 = Monday, and so on
	@@standard_times_by_day = [[],[],7..11,16..20,4..20,7..11,10..18]
	@@minimum_hours_after_present_for_delivery = 36
	@@number_of_days_ahead_delivery_available = 30
	@@utc_offset = "-07:00"

	attr_accessor :posted_delivery_date, :posted_delivery_time, :skip_delivery_validation, :skip_confirm_request_email

	belongs_to :user
	belongs_to :driver, class_name: 'User'
	has_many :notifications
	has_paper_trail

	validates :user_id, presence: true

	def self.delivery_time_available?(time)
		within_standard_times?(time) and fits_with_other_delivery_times?(time, all)
	end

	def self.taken_delivery_times(from_time=Time.now.getlocal(@@utc_offset))
		taken_times = {}
		self.where(completion_time: nil, delivery_time:(from_time.to_date..(from_time+@@number_of_days_ahead_delivery_available.days).to_date)).select(:delivery_time).each do |request|
			time_format = '%m/%d/%Y'
			delivery_time = request.delivery_time
			date_string = delivery_time.strftime(time_format)
			hour1 = delivery_time.hour
			hour2 = if delivery_time.min > 0 then delivery_time.hour + 1 else nil end
			if taken_times[date_string]
				taken_times[date_string] << hour1
			else
				taken_times[date_string] = [hour1]
			end
			taken_times[date_string] << hour2 if hour2
		end
		taken_times
	end

	def self.available_delivery_times(from_time=Time.now.getlocal(@@utc_offset))
		time_format = '%m/%d/%Y'
		available_times = {}
		available_times[from_time.strftime(time_format)] = @@standard_times_by_day[from_time.wday].to_a.select {|time| time >= from_time.hour + @@minimum_hours_after_present_for_delivery}
		(@@number_of_days_ahead_delivery_available - 1).times do |i|
			time = from_time + (i+1).days
			available_times[time.strftime(time_format)] = @@standard_times_by_day[time.wday].to_a
		end
		UnavailableTime.where(start_time: (from_time.to_date..(from_time+@@number_of_days_ahead_delivery_available.days).to_date)).each do |ut|
			date_string = ut.start_time.strftime(time_format)
			blocked_hours = (ut.start_time.hour..ut.end_time.hour).to_a
			blocked_hours.each do |blocked_hour|
				if available_times[date_string]
					available_times[date_string].delete(blocked_hour)
				end
			end
		end
		self.where(completion_time: nil, delivery_time:(from_time.to_date..(from_time+@@number_of_days_ahead_delivery_available.days).to_date)).select(:delivery_time).each do |request|
			delivery_time = request.delivery_time
			date_string = delivery_time.strftime(time_format)
			hour1 = delivery_time.hour
			hour2 = if delivery_time.min > 0 then delivery_time.hour + 1 else nil end
			if available_times[date_string]
				available_times[date_string].delete(hour1)
				if hour2 then available_times[date_string].delete(hour2) end
			end
		end
		available_times
	end

	def time_to_edit
		current_time = Time.now.getlocal(@@utc_offset)
		return true if self.delivery_time - current_time >= 1.day
		return false
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
		now = Time.now.getlocal(@@utc_offset).round(0)
		return false if time < (now - now.min.minutes - now.sec.seconds) + @@minimum_hours_after_present_for_delivery.hours
		# return true
		return time.hour.in? @@standard_times_by_day[time.wday]
	end

	def self.fits_with_other_delivery_times?(time, requests)
		not requests.where(completion_time: nil, delivery_time: (time - 59.minutes)..(time + 59.minutes)).exists?
	end
end