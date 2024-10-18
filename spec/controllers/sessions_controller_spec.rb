# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  render_views

  let(:user) { create(:user, email: 'user@example.com', password: 'password') }

  describe 'GET #new' do
    context 'when user is logged in' do
      before { session[:user_id] = user.id }

      it 'redirects to root path' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      it 'renders the new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'logs in the user and redirects to root path' do
        post :create, params: { email: user.email, password: 'password' }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid credentials' do
      it 'redirects to login path with an alert' do
        post :create, params: { email: user.email, password: 'wrongpassword' }
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq('Invalid email or password')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { session[:user_id] = user.id }

    it 'logs out the user and redirects to login path' do
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(login_path)
    end
  end
end
