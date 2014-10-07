class AddPromoCodeAndReferrerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :promo_code, :string
    add_column :users, :referrer, :string
  end
end
