module Api
	class ApplicationController < ActionController::API

		before_action :doorkeeper_authorize!


		private

		def current_user
		  if doorkeeper_token
		    Rails.logger.debug "Doorkeeper Token: #{doorkeeper_token.inspect}"
		    @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id)
		  else
		    Rails.logger.debug "No valid token found"
		    nil
		  end
        end
	end
end