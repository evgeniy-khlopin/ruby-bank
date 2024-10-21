# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BankTransactionsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let!(:from_account) { create(:bank_account, user:, balance: 1000) }
  let!(:to_account) { create(:bank_account, balance: 500) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    context 'when transfer is successful' do
      it 'creates a new transaction and updates balances' do
        post :create,
             params: { from_bank_account_id: from_account.id, to_bank_account_id: to_account.id, amount: 200 }, format: :turbo_stream

        expect(assigns(:bank_account)).to eq(from_account)
        expect(assigns(:user)).to eq(user)
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        expect(flash.now[:notice]).to eq('Transfer completed successfully')
      end
    end

    context 'when transfer fails' do
      before do
        allow(Transaction::TransferService).to receive(:call).and_return(OpenStruct.new(success?: false,
                                                                                        errors: { base: ['Insufficient balance'] }))
      end

      it 'renders an error flash message' do
        post :create,
             params: { from_bank_account_id: from_account.id, to_bank_account_id: to_account.id, amount: 1500 }, format: :turbo_stream

        expect(flash.now[:error]).to eq('Insufficient balance')
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end
  end
end
