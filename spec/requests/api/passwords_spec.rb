require 'rails_helper'

RSpec.describe "Password API", type: :request do
  let(:user) { create(:user) }
  let(:application) { create(:doorkeeper_application) }

  let(:access_token) do
    Doorkeeper::AccessToken.create(
      resource_owner_id: user.id,
      application_id: application.id,
      scopes: 'public'
    ).token
  end

  describe "POST /api/password" do
    it "should succeed with valid forget password request" do
      headers = { 'Authorization' => "Bearer #{access_token}" }
      post '/api/password', params: { email: user.email }, headers: headers

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response["message"]).to eq("Password reset instruction sent")
    end

    it "should failure with invalid token" do
    	headers = { 'Authorization' => "Bearer #{access_token}" }
    	post '/api/password', params: { email: user.email }

    	expect(response).to have_http_status(:unauthorized)
    end
  end

    describe "PATCH /api/password" do
	  it "should succeed with valid reset password params" do
	   
	    reset_password_token = user.send_reset_password_instructions

	    
	    token_digest = Devise.token_generator.digest(User, :reset_password_token, reset_password_token)

	   
	    user.update!(reset_password_token: token_digest, reset_password_sent_at: Time.now)
        new_password = Faker::Internet.password(min_length: 8)
	    headers = { 'Authorization' => "Bearer #{access_token}" }
	    patch '/api/password', 
	          params: { reset_password_token: reset_password_token,
	                    password: new_password,
	                    password_confirmation: new_password }, 
	          headers: headers

	    expect(response).to have_http_status(:ok)
	    parsed_response = JSON.parse(response.body)

	    expect(parsed_response["message"]).to eq("Password has been reset successfully!")
	  end

	  it "should failure with invalid reset_password_token" do
          reset_password_token = user.send_reset_password_instructions

	    
	    token_digest = Devise.token_generator.digest(User, :reset_password_token, reset_password_token)

	   
	    user.update!(reset_password_token: token_digest, reset_password_sent_at: Time.now)
        new_password = Faker::Internet.password(min_length: 8)
	    headers = {'Authorization' => "Bearer#{access_token}"}
	    patch '/api/password',
	           params: { reset_password_token: "",
	           	         password: new_password,
	           	         password_confirmation: new_password },

	           	    headers: headers
	           	    
	    expect(response).to have_http_status(:unauthorized)           
	  end

	    it "should failure with invalid token" do
	  	  reset_password_token = user.send_reset_password_instructions

	  	  token_digest = Devise.token_generator.digest(User, :reset_password_token, reset_password_token)


	  	  user.update!(reset_password_token: token_digest, reset_password_sent_at: Time.now)
          new_password = Faker::Internet.password(min_length: 8)
	  	  headers = {'Authorization' => "Bearer#{access_token}"}
          patch '/api/password',
                 params: { reset_password_token: reset_password_token,
                 	       password: new_password,
                 	       password_confirmation: new_password }


           expect(response).to have_http_status(:unauthorized)      	       
	    end
    end
end
