class Share < ActiveRecord::Base
	
	def self.insert_data(send_to, current_user, nature_id)
		Share.create(:receiver => send_to, :sender => current_user.email, :nature_id => nature_id)
	end
end
