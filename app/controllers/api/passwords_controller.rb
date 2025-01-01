module Api
	class PasswordsController < Api::ApplicationController
		skip_before_action :doorkeeper_authorize!

		def create
			user = User.find_by(email: params[:email])
			if user.send_reset_password_instructions

				render json: {message: "Password reset instruction sent"}, status: :ok
			else
			
			   render json: {error: "Email not found"}
			end	
		end

		def update
			user = User.reset_password_by_token(password_params)
			if user.errors.empty?
				render json: {message: "Password has been reset successfully!"}, status: :ok
			else
			   render json: {error: user.errors.full_messages}, status: :unprocessable_entity
			end	
		end

		def change_password
			if current_user&.update_with_password(change_password_params)
				render json: {message: "Password updated successfully"}, status: :ok
			else
			    render json: {error: "Password not change" }, status: :unprocessable_entity
			end 	
		end

		private

		def password_params
			params.permit(:reset_password_token, :password, :password_confirmation)
		end

		def change_password_params
			params.permit(:current_password, :password, :password_confirmation)
		end
	end
end