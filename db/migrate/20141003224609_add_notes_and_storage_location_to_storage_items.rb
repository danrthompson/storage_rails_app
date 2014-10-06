class AddNotesAndStorageLocationToStorageItems < ActiveRecord::Migration
  def change
    add_column :storage_items, :notes, :text
    add_column :storage_items, :storage_location, :text
  end
end
