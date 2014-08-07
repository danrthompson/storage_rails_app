class AddNewFieldsToStorageItems < ActiveRecord::Migration
  def change
    add_column :storage_items, :title, :string
    add_column :storage_items, :description, :text
    add_column :storage_items, :entered_storage_at, :datetime
  end
end
