module Textable
	extend ActiveSupport::Concern

	module ClassMethods
		def send_text(message, numbers)
			begin
				client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']

				numbers.each do |number|
					begin
						client.account.messages.create({
							from: '+17209033991',
							to: number,
							body: message
						})
					rescue Twilio::REST::RequestError => e
						puts e.message
					end
				end
			rescue Twilio::REST::RequestError => e
				puts e.message
			end
		end

		def send_admin_text(message)
			self.send_text(message, ['720-404-5623', '210-410-5804', '720-422-3354', '814-288-7620'])
		end
	end
end