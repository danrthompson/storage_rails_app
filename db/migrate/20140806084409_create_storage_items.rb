class CreateStorageItems < ActiveRecord::Migration
  def change
    create_table :storage_items do |t|
      t.belongs_to :user, index: true
      t.string :type
    end
  end
end
