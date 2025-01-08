require 'rails_helper'

RSpec.describe 'User API', type: :request do
  let(:client_app) { create(:doorkeeper_application) }

  describe 'POST create user' do
    context 'when the request is valid' do
      let(:valid_params) do
        {
          email: Faker::Internet.email,
          password: Faker::Internet.password,
          client_id: client_app.uid
        }
      end

      it 'creates the user successfully' do
        post '/api/create', params: valid_params

        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)

        expect(parsed_response['user']['email']).to eq(valid_params[:email])
        expect(parsed_response['user']).to include('id', 'email', 'access_token', 'refresh_token')
        expect(parsed_response['user']['token_type']).to eq('bearer')
      end
    end

    context 'when client_id is invalid' do

    	let(:invalid_client_id) do
    		{
    		email: Faker::Internet.email,
    		password: Faker::Internet.password,
    		client_id: 'invalid_client_id'
    	}
    	end

    	it 'should failure with invalid client_id ' do
    		post '/api/create', params: invalid_client_id

    		expect(response).to have_http_status(:forbidden)
    		parsed_response = JSON.parse(response.body)

    		expect(parsed_response["error"]).to eq('Invalid client ID')
    	end
    end

    context 'when email is missing' do

    	let(:invalid_email) do
    		{
    		email: "",
    		password: Faker::Internet.password,
    		client_id: client_app.uid	
    		}
    	end

    	it 'should failure with empty email' do
    		post '/api/create', params: invalid_email

    		expect(response).to have_http_status(:unprocessable_content)
    		parsed_response = JSON.parse(response.body)

    		expect(parsed_response['error']).to eq(["Email can't be blank", "Email is invalid"])
    	end
    end
  end
end
