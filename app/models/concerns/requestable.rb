module Requestable
	extend ActiveSupport::Concern

	included do
		belongs_to :user
		belongs_to :driver, class_name: 'User'
		validates :user_id, :delivery_time, presence: true
	end
end