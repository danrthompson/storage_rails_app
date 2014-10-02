# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Request.delete_all
UnavailableTime.delete_all
StorageItem.delete_all
User.delete_all
Notification.delete_all

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
	phone_number: '814.288.7620',
	cc_name: 'Dan Thompson',
	cc_number: '1234567890123456',
	exp_month: '10',
	exp_year: '2016',
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

valid_delivery_time = Time.now
valid_delivery_time.change hour: 18, minute: 0

PackingSuppliesRequest.create!({
	user_id: user1.id,
	delivery_time: valid_delivery_time + 1.day,
	box_quantity: 1,
})

PackingSuppliesRequest.create!({
	user_id: user2.id,
	delivery_time: valid_delivery_time + 2.days,
	box_quantity: 3,
})

pickup_request_1 = PickupRequest.create!({
	user_id: user1.id,
	delivery_time: valid_delivery_time + 3.days,
	small_item_quantity: 1,
	large_item_quantity: 2,
})

PickupRequest.create!({
	user_id: user2.id,
	delivery_time: valid_delivery_time + 4.days,
	extra_large_item_quantity: 2,
	large_item_quantity: 1,
	driver_id: admin.id,
	completion_time: valid_delivery_time + 4.days + 2.hours + 30.minutes,
})

StorageItem.create!({
	user_id: user1.id,
	entered_storage_at: valid_delivery_time - 1.day,
	item_type: 'small',
	title: "cocaine and sex toys",
	description: "La ac consectetur ac, vestibulum at eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
	pickup_request_id: pickup_request_1.id
})

StorageItem.create!({
	user_id: user1.id,
	entered_storage_at: valid_delivery_time - 1.day,
	item_type: 'small',
	title: "guitars & music items",
	description: "La ac consectetur ac, vestibulum at eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
	pickup_request_id: pickup_request_1.id
})

StorageItem.create!({
	user_id: user1.id,
	entered_storage_at: valid_delivery_time - 1.day,
	item_type: 'medium',
	title: "sex_couch",
	description: "La ac consectetur ac, vestibulum at eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
	pickup_request_id: pickup_request_1.id
})





