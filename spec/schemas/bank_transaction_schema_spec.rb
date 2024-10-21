require 'rails_helper'

RSpec.describe BankTransactionSchema do
  let(:valid_input) do
    {
      transaction_number: SecureRandom.uuid,
      transaction_type: 'transfer',
      amount: 500.0,
      balance_before: 1000.0,
      balance_after: 500.0,
      bank_account_id: 1,
      target_bank_account_id: 2,
      details: 'Payment for services'
    }
  end

  context 'with valid input' do
    it 'passes validation' do
      result = BankTransactionSchema.new.call(valid_input)
      expect(result.success?).to be(true)
      expect(result.errors.to_h).to be_empty
    end
  end

  context 'with invalid input' do
    it 'fails when transaction_number is missing' do
      input = valid_input.merge(transaction_number: nil)
      result = BankTransactionSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(transaction_number: ['must be filled'])
    end

    it 'fails when transaction_type is invalid' do
      input = valid_input.merge(transaction_type: 'invalid_type')
      result = BankTransactionSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(transaction_type: ['is not a valid transaction type'])
    end

    it 'fails when amount is missing' do
      input = valid_input.merge(amount: nil)
      result = BankTransactionSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(amount: ['must be filled'])
    end

    it 'fails when amount is negative' do
      input = valid_input.merge(amount: -500.0)
      result = BankTransactionSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(amount: ['must be greater than 0'])
    end

    it 'fails when balance_before is negative' do
      input = valid_input.merge(balance_before: -100.0)
      result = BankTransactionSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(balance_before: ['must be greater than or equal to 0'])
    end
  end
end
