module Requestable
	extend ActiveSupport::Concern

	included do
		validates :user_id, :delivery_time, presence: true
		belongs_to :user
		belongs_to :driver, class_name: 'User'
	end
end