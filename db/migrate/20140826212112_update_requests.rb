class UpdateRequests < ActiveRecord::Migration
  def up
  	add_column :requests, :tape_quantity, :integer
  	remove_column :requests, :file_box_quantity
  	remove_column :requests, :couch_quantity
  end

  def down
  	remove_column :requests, :tape_quantity
  	add_column :requests, :file_box_quantity, :integer
  	add_column :requests, :couch_quantity, :integer
  end
end
