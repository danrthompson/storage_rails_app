class AddNameToUsers < ActiveRecord::Migration
  def up
    add_column :users, :name, :string

    User.all.each do |user|
    	# if they have a first name and a last name
    	if not (user.first_name.blank? or user.last_name.blank?)
    		user.name = "#{user.first_name} #{user.last_name}"
    	# if they dont have a first name or a last name
    	elsif user.first_name.blank? and user.last_name.blank?
    		user.name = ""
    	# if they only have a last name
    	elsif user.first_name.blank?
    		user.name = user.last_name
    	# if they only have a first name
    	elsif user.last_name.blank?
    		user.name = user.first_name
    	end
    	user.save
    end

    remove_column :users, :first_name
    remove_column :users, :last_name
  end

  def down
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string

  	User.all.each do |user|
  		user.first_name = user.name
  		user.save
  	end

  	remove_column :users, :name
  end
end
