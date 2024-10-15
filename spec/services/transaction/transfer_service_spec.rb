# spec/services/transaction/transfer_service_spec.rb
require 'rails_helper'

RSpec.describe Transaction::TransferService, type: :service do
  let(:from_user) { create(:user) }
  let(:to_user) { create(:user) }
  let(:from_account) { create(:bank_account, user: from_user, balance: 1000.0) }
  let(:to_account) { create(:bank_account, user: to_user, balance: 500.0) }
  let(:amount) { 300.0 }

  subject(:service) do
    described_class.call(
      from_bank_account_id: from_account.id,
      to_bank_account_id: to_account.id,
      amount:
    )
  end

  describe 'successful transfer' do
    it 'creates an outgoing transaction from the sender account' do
      expect { service }.to change { from_account.reload.balance }.by(-amount)
    end

    it 'creates an incoming transaction for the recipient account' do
      expect { service }.to change { to_account.reload.balance }.by(amount)
    end

    it 'returns success if both transactions are created' do
      expect(service).to be_success
    end
  end

  describe 'failure due to insufficient funds' do
    let(:amount) { 1500.0 }

    it 'fails the service and does not change the sender account balance' do
      expect(service).to be_failure
      expect(service.errors[:base]).to include("Transaction failed: Account #{from_account.account_number} has insufficient balance")
      expect(from_account.reload.balance).to eq(1000.0)
    end

    it 'does not change the recipient account balance' do
      service
      expect(to_account.reload.balance).to eq(500.0)
    end
  end

  describe 'failure due to CreateTransactionService failure' do
    before do
      allow(Transaction::CreateTransactionService).to receive(:call).and_return(
        double(success?: false, errors: OpenStruct.new(full_messages: ['Transaction error']))
      )
    end

    it 'fails the transfer and adds an error' do
      expect(service).to be_failure
      expect(service.errors[:base]).to include('Transaction failed: Transaction error')
    end
  end
end
