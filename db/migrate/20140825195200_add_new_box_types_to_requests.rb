class AddNewBoxTypesToRequests < ActiveRecord::Migration
  def change
  	add_column :requests, :wardrobe_box_quantity, :integer
  	add_column :requests, :bubble_quantity, :integer
  	add_column :requests, :file_box_quantity, :integer
  	add_column :requests, :poster_tube_quantity, :integer
  end
end
