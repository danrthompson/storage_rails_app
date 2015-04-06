class AddProposedTimesToUsers < ActiveRecord::Migration
  def change
    add_column :requests, :proposed_times, :text
    add_column :requests, :proposed_date, :datetime
  end
end
