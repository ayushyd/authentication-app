require 'rails_helper'

RSpec.describe 'User Authentication', type: :request do
  let(:user) { create(:user) }
  let(:application) { create(:doorkeeper_application) }

  describe 'POST /oauth/token' do
    context 'with valid credentials' do
      let(:valid_params) do
        {
          grant_type: 'password',
          email: user.email,
          password: user.password,
          client_id: application.uid,
          client_secret: application.secret
        }
      end

      it 'logs in successfully and returns an access token' do
        post '/oauth/token', params: valid_params

        expect(response).to have_http_status(:ok)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key('access_token')
        expect(parsed_response).to have_key('refresh_token')
      end
    end

    context 'with invalid credentials' do
    	let(:invalid_params) do
    		{
    			grant_type: 'password',
    			email: user.email,
    			password: user.password,
    			client_id: " ",
    			client_secret: " "
    		}
    	end

    	it "login failure with invalid client"do 
    	   post '/oauth/token', params: invalid_params

    	   expect(response).to have_http_status(:unauthorized)

    	   parsed_response = JSON.parse(response.body)
    	   expect(parsed_response["error"]).to eq('invalid_client')
    	   expect(parsed_response["error_description"]).to eq('Client authentication failed due to unknown client, no client authentication included, or unsupported authentication method.')
        end
    end

    context 'login failure' do
    	let(:email_params) do
    		{

    		grant_type: 'password',
    		email: " ",
    		password: user.password,
    		client_id: application.uid,
    		client_secret: 	application.secret
    		}
    	end

    	it "login failure with invalid email" do
    		post '/oauth/token', params: email_params

    		expect(response).to have_http_status(:bad_request)

    		parsed_response = JSON.parse(response.body)
    		expect(parsed_response["error"]).to eq('invalid_grant')
    	end
    end
  end
end
