require 'rails_helper'

RSpec.describe BankTransactionSchema do
  let(:valid_input) do
    {
      transaction_number: SecureRandom.uuid,
      transaction_type: 'transfer',
      amount: 500.0,
      balance_before: 1000.0,
      balance_after: 500.0,
      from_bank_account_id: 1,
      to_bank_account_id: 2,
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

    it 'fails when balance_after is negative' do
      input = valid_input.merge(balance_after: -100.0)
      result = BankTransactionSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(balance_after: ['must be greater than or equal to 0'])
    end

    it 'fails when both from_bank_account_id and to_bank_account_id are missing' do
      input = valid_input.merge(from_bank_account_id: nil, to_bank_account_id: nil)
      result = BankTransactionSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(from_bank_account_id: ['either from_bank_account_id or to_bank_account_id must be present'])
    end
  end
end
