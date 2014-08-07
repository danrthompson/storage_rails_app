class AddDriverIdsToRequests < ActiveRecord::Migration
  def change
  	add_column :box_requests, :driver_id, :integer
  	add_column :delivery_requests, :driver_id, :integer
  	add_column :pickup_requests, :driver_id, :integer
  end
end
