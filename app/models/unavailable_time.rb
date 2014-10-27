class UnavailableTime < ActiveRecord::Base
  attr_accessor :unavailable_date, :start_hour, :end_hour

  belongs_to :user

  before_save :normalize_time

  def normalize_time
  	if not (self.start_hour.blank? or self.end_hour.blank?) and self.start_hour < self.end_hour
	  	self.start_time = Date.strptime(self.unavailable_date, '%m/%d/%Y') + self.start_hour.to_i.hours
  		self.end_time = Date.strptime(self.unavailable_date, '%m/%d/%Y') + self.end_hour.to_i.hours
  	end
  end
end
