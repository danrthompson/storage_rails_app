class AddAttachmentImageToStorageItems < ActiveRecord::Migration
  def self.up
    change_table :storage_items do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :storage_items, :image
  end
end
