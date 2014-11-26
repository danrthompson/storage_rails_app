class AddOneTimePaymentToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :one_time_payment, :float
  end
end
