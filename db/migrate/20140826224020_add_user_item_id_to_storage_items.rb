class AddUserItemIdToStorageItems < ActiveRecord::Migration
  def change
  	add_column :storage_items, :user_item_number, :integer
  end
end
