class AddDiscountToStorageItems < ActiveRecord::Migration
  def change
    add_column :storage_items, :discount, :float
  end
end
