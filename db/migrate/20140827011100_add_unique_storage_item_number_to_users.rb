class AddUniqueStorageItemNumberToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :storage_item_number, :integer, default: 1
  end
end
