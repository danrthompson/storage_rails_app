class AddDriverNameAndDriverNotesToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :driver_name, :string
    add_column :requests, :driver_notes, :text
  end
end
