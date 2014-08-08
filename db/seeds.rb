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
	phone_number: '814.288.7620'
})

admin = User.create!({
	email: 'admin@admin.admin',
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

BoxRequest.create!({
	user_id: user1.id,
	delivery_time: Time.now + 1.day,
	box_quantity: 1,
})

BoxRequest.create!({
	user_id: user2.id,
	delivery_time: Time.now + 2.days,
	box_quantity: 3,
})

PickupRequest.create!({
	user_id: user1.id,
	delivery_time: Time.now + 3.days,
	box_quantity: 1,
	couch_quantity: 2,
})

PickupRequest.create!({
	user_id: user2.id,
	delivery_time: Time.now - 1.day,
	box_quantity: 2,
	couch_quantity: 1,
	driver_id: admin.id,
	completion_time: Time.now - 1.day + 2.hours + 30.minutes,
})

