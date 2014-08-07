class AddLeftStorageToStorageItems < ActiveRecord::Migration
  def change
    add_column :storage_items, :left_storage_at, :datetime
  end
end
