class AddConversionTrackingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :conversion_tracked, :boolean
  end
end
