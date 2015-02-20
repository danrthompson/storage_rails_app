class AddPlannedDurationToStorageItems < ActiveRecord::Migration
  def change
    add_column :storage_items, :planned_duration, :integer, default: 1
  end
end
