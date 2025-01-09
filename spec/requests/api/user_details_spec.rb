require 'rails_helper'

RSpec.describe 'GET /api/user_details', type: :request do
  let(:user) { create(:user) }
  let(:application) { create(:doorkeeper_application) }
  let(:access_token) do
    Doorkeeper::AccessToken.create(
      resource_owner_id: user.id,
      application_id: application.id,
      scopes: 'public'
    ).token
  end

  describe 'GET /api/user_details' do
    it 'should successfully return user details' do
      headers = { 'Authorization' => "Bearer #{access_token}" }
      get '/api/user_details', headers: headers

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['user']['email']).to eq(user.email)
      expect(parsed_response['user']['id']).to eq(user.id)
    end

    it 'should failure with invalid token' do
      headers = { 'Authorization' => "Bearer #{access_token}" }
      get '/api/user_details'

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
