class CreateUnavailableTimes < ActiveRecord::Migration
  def change
    create_table :unavailable_times do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
