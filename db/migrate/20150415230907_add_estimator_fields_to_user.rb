class AddEstimatorFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :estimator_small_item_quantity, :integer
    add_column :users, :estimator_medium_item_quantity, :integer
    add_column :users, :estimator_large_item_quantity, :integer
    add_column :users, :estimator_extra_large_item_quantity, :integer
    add_column :users, :estimator_duration, :integer
    add_column :users, :estimator_skip_pickup_request, :boolean
  end
end
