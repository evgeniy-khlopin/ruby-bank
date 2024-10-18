# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BankAccountsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:bank_account) { create(:bank_account, user: user) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    context 'when user is authenticated' do
      it 'assigns the requested bank account to @bank_account' do
        get :show, params: { id: bank_account.id }, format: :turbo_stream
        expect(assigns(:bank_account)).to eq(bank_account)
      end

      it 'assigns the user to @user' do
        get :show, params: { id: bank_account.id }, format: :turbo_stream
        expect(assigns(:user)).to eq(user)
      end

      it 'responds with turbo stream format' do
        get :show, params: { id: bank_account.id }, format: :turbo_stream
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end
  end
end
