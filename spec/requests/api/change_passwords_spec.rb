require 'rails_helper'

RSpec.describe 'Change Password API', type: :request do
  let(:user) { create(:user, password: 'sameer123', password_confirmation: 'sameer123') }
  let(:application) { create(:doorkeeper_application) }

  let(:access_token) do
    Doorkeeper::AccessToken.create(
      resource_owner_id: user.id,
      application_id: application.id,
      scopes: 'public'
    ).token
  end

  describe 'PATCH /api/change_password' do
    context 'when valid parameters are provided' do
      it 'should succeed in changing the password' do
        new_password = '1234567'
        headers = { 'Authorization' => "Bearer #{access_token}" }

        patch '/api/change_password',
              params: {
                user: {
                  current_password: 'sameer123', 
                  password: new_password,
                  password_confirmation: new_password
                }
              },
              headers: headers

        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)

        expect(parsed_response['message']).to eq('Password updated successfully')
      end
    end

    context 'when the current password is invalid' do
      it 'should return an error' do
        new_password = '1234567'
        headers = { 'Authorization' => "Bearer #{access_token}" }

        patch '/api/change_password',
              params: {
                user: {
                  current_password: 'fhuehf',
                  password: new_password,
                  password_confirmation: new_password
                }
              },
              headers: headers

      
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)

        expect(parsed_response['error']).to eq('Password not change')
      end
    end

    context 'when password confirmation does not match' do
      it 'should return an error' do
        headers = { 'Authorization' => "Bearer #{access_token}" }

        patch '/api/change_password',
              params: {
                user: {
                  current_password: 'sameer123',
                  password: '1234567',
                  password_confirmation: 'mismatch_password'
                }
              },
              headers: headers

       
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)

        expect(parsed_response['error']).to eq("Password not change")
      end
    end

    context 'when token is invalid' do
    	it 'should failure with invalid token' do
    		new_password = '1234567'
    		headers = {'Authorization' => "Bearer#{access_token}"}

    		patch '/api/change_password',
    		params: {
    			user: {
    				current_password: 'sameer123',
    				password: new_password,
    				password_confirmation: new_password
    			}
    		}

    		expect(response).to have_http_status(:unauthorized)
    	end
    end
  end
end
