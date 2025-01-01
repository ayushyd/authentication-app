module Api
	class ApplicationController < ActionController::API

		before_action :doorkeeper_authorize!


		private

		def current_user
            @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
        end
	end
end