class CreateBoxRequests < ActiveRecord::Migration
  def change
    create_table :box_requests do |t|
      t.belongs_to :user, index: true
      t.datetime :delivery_time
      t.datetime :completion_time
      t.integer :box_quantity
    end
  end
end
