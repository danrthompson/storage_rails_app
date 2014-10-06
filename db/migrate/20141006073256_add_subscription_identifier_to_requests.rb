class AddSubscriptionIdentifierToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :stripe_subscription_identifier, :string
  end
end
