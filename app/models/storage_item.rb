class StorageItem < ActiveRecord::Base

	validates :entered_storage_at, :user_id, :type, presence: true
	validates :type, inclusion: { in: self.types, message: 'must be a real type.' }
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	has_attached_file :image, :default_url => "/images/default_box_image.png"
	belongs_to :user
	belongs_to :delivery_request

	def self.types
		%w(box couch)
	end

	def price(type)
		case type
		when 'box'
			5.0
		when 'couch'
			20.0
		else
			nil
		end
	end

end