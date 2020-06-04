require 'rails_helper'

RSpec.describe "Users", type: :request do

  let(:params) { { email: email, password: password, password_confirmation: password_confirmation} }
  let(:email) { 'test@mail.com' }
  let(:password) { '123456789' }
  let(:password_confirmation) { '123456789' }

  describe 'Signup workflow' do
    context 'with valid params' do
      it 'should create a user' do
        post '/signup', params: params

        expect(User.count).to be(1)
      end

      it 'should fill up username with email prefixing' do
        post '/signup', params: params

        expect(User.first[:username]).to eql("test")
      end
    end

    context 'with invalid params' do
      it 'should not sign up when email is missing' do
        params[:email] = ""
        post '/signup', params: params

        expect(User.count).to be(0)
      end

      it 'should not sign up when password is missing' do
        params[:password] = ""
        post '/signup', params: params
        expect(User.count).to be(0)
      end

      it 'should not sign up when password confirmation mismatching' do
        params[:password_confirmation] = "mismatching one here"
        post '/signup', params: params
        expect(User.count).to be(0)
      end

      it 'should not sign up when password length is shorter than 8' do
        pollution = {
          password: "12345",
          password_confirmation: "12345"
        }
        post '/signup', params: params.merge!(pollution)
        expect(User.count).to be(0)
      end
    end
  end

  describe 'Profile update workflow' do
    before(:each) do
      post '/signup', params: params
      puts "new user is created"
    end

    it 'should update user name when its valid' do
      update_params = {
        user: {
          username: "Happy Coding"
        }
      }
      post '/profile', params: update_params
      expect(User.first[:username]).to eql("Happy Coding")
    end

    it 'should not update user name when its not valid' do
      update_params = {
        user: {
          username: "Cat"
        }
      }
      post '/profile', params: update_params
      expect(User.first[:username]).to eql("test")
    end
  end
end
