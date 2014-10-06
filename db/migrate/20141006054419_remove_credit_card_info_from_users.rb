class RemoveCreditCardInfoFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :cc_name
    remove_column :users, :cc_number
    remove_column :users, :exp_month
    remove_column :users, :exp_year
  end

  def down
    add_column :users, :cc_name, :string
    add_column :users, :cc_number, :string
    add_column :users, :exp_month, :string
    add_column :users, :exp_year, :string
  end
end
