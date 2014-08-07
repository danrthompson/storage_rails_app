Data model:
User
	email
	password
	first_name
	last_name
	address_line_1
	address_line_2
	city
	state
	zip
	special_instructions
	phone_number

	has_many box_requests, delivery_requests, pickup_requests, storage_items
?	has_many box_requests, delivery_requests, pickup_requests AS driver

BoxRequest
	user_id
	driver_id
	delivery_time
	box_quantity
	completion_time

	belongs_to user
?	belongs_to driver

DeliveryRequest
	user_id
	driver_id
	delivery_time
	completion_time

	belongs_to user
?	belongs_to driver
	has_many storage_items

PickupRequest
	user_id
	driver_id
	delivery_time
	box_quantity
	couch_quantity
	completion_time

	belongs_to user
?	belongs_to driver

StorageItem
	user_id
	delivery_request_id
	type
	image
	title
	description
	entered_storage_at
	left_storage_at

	belongs_to user
	belongs_to delivery_request