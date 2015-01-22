class AddTireCustomerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tire_customer, :boolean
  end
end
