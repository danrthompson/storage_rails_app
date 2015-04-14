class AddDeliveryFeeToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :delivery_fee, :float
  end
end
