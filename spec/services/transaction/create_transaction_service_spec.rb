# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::CreateTransactionService, type: :service do
  let(:user) { create(:user) }
  let(:bank_account) { create(:bank_account, user:, balance: 1000.0) }
  let(:amount) { 500.0 }
  let(:transaction_type) { :transfer }

  subject(:service) do
    described_class.call(
      amount:,
      bank_account_id: bank_account.id,
      transaction_type:
    )
  end

  describe 'Outgoing transaction' do
    context 'when the balance is sufficient' do
      let(:transaction_type) { :transfer }

      it 'creates the transaction successfully' do
        expect(service).to be_success
        expect(bank_account.reload.balance).to eq(500.0)
      end

      it 'returns a valid transaction record' do
        transaction = service.result
        expect(transaction.amount).to eq(amount)
        expect(transaction.transaction_type).to eq('transfer')
        expect(transaction.bank_account_id).to eq(bank_account.id)
      end
    end

    context 'when the balance is insufficient' do
      let(:amount) { 1500.0 }
      let(:transaction_type) { :transfer }

      it 'fails and does not create the transaction' do
        expect(service).to be_failure
        expect(service.errors[:base]).to include("Account #{bank_account.account_number} has insufficient balance")
        expect(bank_account.reload.balance).to eq(1000.0)
      end
    end
  end

  describe 'Incoming transaction' do
    let(:transaction_type) { :credit }

    it 'creates the transaction and increases the balance' do
      expect(service).to be_success
      expect(bank_account.reload.balance).to eq(1500.0)
    end

    it 'returns a valid incoming transaction record' do
      transaction = service.result
      expect(transaction.amount).to eq(amount)
      expect(transaction.transaction_type).to eq('credit')
      expect(transaction.bank_account_id).to eq(bank_account.id)
    end
  end
end
