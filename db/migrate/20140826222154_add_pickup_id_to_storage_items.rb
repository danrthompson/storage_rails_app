class AddPickupIdToStorageItems < ActiveRecord::Migration
  def change
  	add_column :storage_items, :pickup_request_id, :integer
  	add_index :storage_items, :pickup_request_id
  end
end
