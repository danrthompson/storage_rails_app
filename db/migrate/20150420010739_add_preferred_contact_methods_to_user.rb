class AddPreferredContactMethodsToUser < ActiveRecord::Migration
  def change
    add_column :users, :prefers_calls, :boolean
    add_column :users, :prefers_texts, :boolean
    add_column :users, :prefers_emails, :boolean
  end
end
