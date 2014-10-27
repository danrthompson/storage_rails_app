class UnavailableTime < ActiveRecord::Base
  attr_accessor :start_date, :start_hour, :end_date, :end_hour

  belongs_to :user

  before_save :normalize_time

  def normalize_time
  	self.start_time = Date.strptime(self.start_date, '%m/%d/%Y') + self.start_hour.to_i.hours
  	self.end_time = Date.strptime(self.end_date, '%m/%d/%Y') + self.end_hour.to_i.hours
  end
end
