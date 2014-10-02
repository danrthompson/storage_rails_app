class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
    	t.belongs_to :user, index: true
    	t.datetime :delivery_time
    	t.datetime :completion_time
    	t.integer :box_quantity
    	t.integer :couch_quantity
    	t.belongs_to :driver
    	t.string :type
        t.timestamps
    end
  end
end
