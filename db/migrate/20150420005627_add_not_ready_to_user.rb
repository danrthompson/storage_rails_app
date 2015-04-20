class AddNotReadyToUser < ActiveRecord::Migration
  def change
    add_column :users, :not_ready, :boolean
  end
end
