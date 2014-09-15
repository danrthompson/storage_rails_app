me:
	edit storage items from dash
	delivery requests from dash
	user edit
	admin
	revise routes
	figure out how to render available pickup times

for DH (new):
	on the signup flow, for the packing supplies page, the price should not be per month
	on the signup flow, it might be good to tell the user that the packing supplies order and the pickup order are both optional. now they can click forward with 0'ed quantities, but they might not know that doing so is "ok." it almost seems like theyre setting up a pickup without anything in it.
	so you live outside boulder modal is just filler text
	we need to update the terms of service modal
	terms of service acceptance checkbox isnt required
	on new packing supplies request page (not in sign up flow), it says "new box request" at the top
	should clear out static pages folder in views
	a lot of urls, especially on the dashboard, are hardcoded, which we should change to the variable paths. ie %a{:href => "packing_supplies_requests/new.html"} should be changed to %a{:href => new_packing_supplies_request_path}
	show (confirm) page for packing supplies requests and pickup requests displays a hardcoded message (your boxes will be delivered on Monday, when i picked a friday)
	pickup request url is broken from dashboard
	edit your listing page is a little rough, and the item id section should probably be a bit more clear for the user
	on the dashboard the text "click items to select them for delivery" probably should not be a link


for DH:
	sign up link should either not exist or it should go to the sign up flow
	on homepage, pay for what you use graphic still uses infinite garage verbage
	on homepage, any item, any size needs to be looked at to make sure it reflects our current model
	check homepage to ensure it corresponds to current pricing
	about us, contact, faq pages give error
	during sign up flow, the links "home" and "faq" probably shouldnt exist. if you do want to keep them, they are currently broken
	on sign up flow, first page (packing supply request), subheader for packing supplies says "we'll bring these items right to your door." we should probably say we'll ship them to you, rather than bring htem to you
	on sign up flow, first page (packing supply request), submit button says "delivery details." on the second page (pickup request) it says "item pickup"
	all price calculator page sections that are connected to editable price fields only update when you click outside the field, but i rarely click outside a field until im ready to click another field or button. thus, the last field probably wont update until the user clicks submit, and therefore the user may see a misestimate in the calculator. i think it would be best to update the calculator anytime the field changes at all (for example, on key down instead of on change), so its more in real time
	sign up flow, first page, placeholder values for packing material quantities are gone, its now just 0, which means that the prices are gone. separately, not all browsers render placeholder values, so we need to put the prices elsewhere anyhow
	on sign up flow, second page (pickup request), the subheader is "you can always edit your pickup or change it when we arrive." love the bit about editing your pickup. the second bit is a bit confusing to me. maybe a modal explaining that they can give us extra items that they didnt note down on hte request or give us fewer items than they did request, with the caveat that they cannot add large or extra-large items if they only scheduled a pickup for small or medium items (since we only sent one driver)
	on the sign up flow, if you put a non-zero quantity for an item in the packing supplies section, then change it back to 0 (either while still on that page, or by returning to that page with the back button), the summary page will ask for details about that packing_supplies_request
	validations need to be by field, not by form or by section or whatever
	on sign up flow, im still required to either do a packing supplies request or a pickup request to proceed through the pickup request page
	validations dont work when you autofill

us
	need to figure out pricing for packing supplies
	need to set up email, facebook, and twitter, or get rid of those items in the footer
	for delivery time, we need to use ajax to pull in available times
	need to render better error messages if thigns dont validate

me
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