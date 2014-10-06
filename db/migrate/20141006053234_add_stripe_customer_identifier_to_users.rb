class AddStripeCustomerIdentifierToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer_identifier, :string
  end
end
