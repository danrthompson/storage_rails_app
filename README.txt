todo:

im concerned that the "unique" id for storage items / users is not going to be unique because the add_user_item_number method is not done atomically (at least i dont think it is)



signup data:
	signup
		standard box q
		wardrobe box q
		bubble wrap q
		file boxes q
		poster tubes q
		delivery date
		delivery time

	user
		addr1
		addr2
		city
		st
		zip
		phone
		message
		email
		password
		pass conf

	second user
		cc name
		cc number
		exp month
		exp year

homepage:
	remove sign up
	get started doesnt work
	get social: facebook and twitter

need to create team@spaceyouneed.com
about page
contact page
faq
signup
	back links dont seem to work on any of the pages
	loading everything when you click the get started link
	confirm page doesnt reflect actual info
	confirm order doesnt submit form
	dont need phone number twice
	checkbox has latin next to it
	no validation
	create user account page says sign in
	missing all box and extra materials quantities, credit card name, cc number, exp month and year, and second phone number
	time is listed as signup: box_quantity
	message, date-picker are not within the signup portion of the form
	what we do, savings, how it works, sign in, and sign up are all still there (but should only be on homepage)


finish models
	users cant delete users as long as they have any active items or outstanding requests
	add better validation for delivery times

remove routes from resources that arent used
add default url to production for emails
clean up all (devise) routes that should not be accessible
come up with better bucket name than 'storage rails app'
fix figaro or come up with alternative
set up after log in and after sign up urls
render error messages on 404 or error
create new aws master keys


rake db:test:clone after migrations

end todo

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