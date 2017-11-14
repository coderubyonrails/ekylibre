class Share < ActiveRecord::Base

	validates :receiver, format: { with: /(\A([a-z]*\s*)*\<*([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\>*\Z)/i }
	
	def self.insert_data(send_to, current_user, nature_id)
		Share.create(:receiver => send_to, :sender => current_user.email, :nature_id => nature_id)
	end
end
