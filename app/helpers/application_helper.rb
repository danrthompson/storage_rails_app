module ApplicationHelper
  def link_to_add_fields(name, f, association, pickup_request)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, pickup_request: pickup_request)
    end
    link_to(name, '#', class: "add_fields btn blue-bg white pull-right", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def text_message_to_team(message)
	# set up a client to talk to the Twilio REST API 
	@client = Twilio::REST::Client.new account_sid, auth_token 		 

	# To Daniel H.
	@client.account.messages.create({
		:from => '+17209033991', 
		:to => '720-404-5623', 
		:body => message,  
	})

	# To Daniel H.
	@client.account.messages.create({
		:from => '+17209033991', 
		:to => '715-222-4686', 
		:body => message,  
	})

	# To Maggie
	@client.account.messages.create({
		:from => '+17209033991', 
		:to => '210-410-5804', 
		:body => message,  
	})

	# To Hillary
	@client.account.messages.create({
		:from => '+17209033991', 
		:to => '720-422-3354', 
		:body => message,  
	})

	# To Dan T.
	@client.account.messages.create({
		:from => '+17209033991', 
		:to => '814-288-7620', 
		:body => message,  
	})
  end
end