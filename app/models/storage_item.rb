class StorageItem < ActiveRecord::Base

	has_attached_file :image, :default_url => "/images/default_box_image.png"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	def self.types
		%w(box couch)
	end

end