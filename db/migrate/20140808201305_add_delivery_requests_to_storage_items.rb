class AddDeliveryRequestsToStorageItems < ActiveRecord::Migration
  def change
  	add_column :storage_items, :delivery_request_id, :integer
  	add_index :storage_items, :delivery_request_id
  end
end
