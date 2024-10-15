require 'rails_helper'

RSpec.describe BankAccountSchema do
  let(:valid_input) do
    {
      account_number: '1234567890123456',
      currency: 'USD',
      balance: 1000.0
    }
  end

  context 'with valid input' do
    it 'passes validation' do
      result = BankAccountSchema.new.call(valid_input)
      expect(result.success?).to be(true)
      expect(result.errors.to_h).to be_empty
    end
  end

  context 'with invalid input' do
    it 'fails when account_number is missing' do
      input = valid_input.merge(account_number: nil)
      result = BankAccountSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(account_number: ['must be filled'])
    end

    it 'fails when currency is missing' do
      input = valid_input.merge(currency: nil)
      result = BankAccountSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(currency: ['must be filled'])
    end

    it 'fails when balance is missing' do
      input = valid_input.merge(balance: nil)
      result = BankAccountSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(balance: ['must be filled'])
    end

    it 'fails when balance is negative' do
      input = valid_input.merge(balance: -500.0)
      result = BankAccountSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(balance: ['must be greater than or equal to 0'])
    end
  end
end
