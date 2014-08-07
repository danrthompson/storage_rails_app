class CreateDeliveryRequests < ActiveRecord::Migration
  def change
    create_table :delivery_requests do |t|
      t.belongs_to :user, index: true
      t.datetime :delivery_time
      t.datetime :completion_time
    end

    add_column :storage_items, :delivery_request_id, :integer
    add_index :storage_items, :delivery_request_id
  end
end
