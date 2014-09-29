class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.belongs_to :user, index: true
    	t.boolean :cleared
    	t.string :message
    	t.belongs_to :request
      t.timestamps
    end
  end
end
