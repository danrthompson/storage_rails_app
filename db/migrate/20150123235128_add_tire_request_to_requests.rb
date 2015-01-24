class AddTireRequestToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :tire_request, :boolean
  end
end
