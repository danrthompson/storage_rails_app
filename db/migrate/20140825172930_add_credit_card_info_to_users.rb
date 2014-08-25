class AddCreditCardInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cc_name, :string
    add_column :users, :cc_number, :string
    add_column :users, :exp_month, :string
    add_column :users, :exp_year, :string
  end
end
