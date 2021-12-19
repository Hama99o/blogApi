require 'rails_helper'

describe RegistrationsController, type: :request do
  let(:user) { build_user }
  let(:existing_user) { create_user }
  let(:signup_url) { '/api/v1/signup' }

  context 'When creating a new user' do
    before do
      post signup_url, params: {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns a token' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns the user email' do
      expect(json['data']).to have_attribute(:email).with_value(user.email)
    end
  end

  context 'with login user' do
    before do
      login_with_api(existing_user)
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns a token' do
      expect(response.headers['Authorization']).to be_present
    end

    context 'with login user and valid email and password' do
      before do
        put signup_url, params: {
          user: {
            email: 'hmmshl@gmail.com',
            password: user.password
          }
        }, headers: {
          'Authorization': response.headers['Authorization']
        }
      end
      it 'updates the user email and password' do
        expect(json['data']).to have_attribute(:email).with_value('hmmshl@gmail.com')
      end
    end
  end
end
