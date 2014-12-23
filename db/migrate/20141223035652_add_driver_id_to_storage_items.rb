class AddDriverIdToStorageItems < ActiveRecord::Migration
  def change
    add_column :storage_items, :driver_id, :integer
  end
end
