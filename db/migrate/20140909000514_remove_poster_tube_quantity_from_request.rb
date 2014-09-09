class RemovePosterTubeQuantityFromRequest < ActiveRecord::Migration
  def up
  	remove_column :requests, :poster_tube_quantity
  end

  def down
  	add_column :requests, :poster_tube_quantity, :integer
  end
end
