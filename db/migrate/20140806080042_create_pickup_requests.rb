class CreatePickupRequests < ActiveRecord::Migration
  def change
    create_table :pickup_requests do |t|
      t.belongs_to :user, index: true
      t.datetime :delivery_time
      t.boolean :completed
      t.integer :box_quantity
      t.integer :couch_quantity
    end
  end
end
