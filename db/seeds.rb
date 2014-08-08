# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

BoxRequest.delete_all
DeliveryRequest.delete_all
PickupRequest.delete_all
StorageItem.delete_all
User.delete_all

user1 = User.create!({
	email: 'a@a.a',
	password: 'password',
	first_name: 'Dan',
	last_name: 'Thompson',
	address_line_1: '1600 15th St',
	address_line_2: 'Apt #323',
	city: 'Boulder',
	state: 'CO',
	zip: '80301',
	special_instructions: nil,
	phone_number: '814.288.7620'
})

user2 = User.create!({
	email: 'b@b.b',
	password: 'password',
	first_name: 'Dan',
	last_name: 'Thompson',
	address_line_1: '1600 15th St',
	address_line_2: 'Apt #323',
	city: 'Boulder',
	state: 'CO',
	zip: '80301',
	special_instructions: nil,
	phone_number: '814.288.7620',
	admin: true
})

box_request1 = BoxRequest.create!({
	user_id: user1.id,
	delivery_time: Time.now,
	box_quantity: 1,
})