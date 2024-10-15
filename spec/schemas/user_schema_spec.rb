require 'rails_helper'

RSpec.describe UserSchema do
  let(:valid_input) do
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@example.com'
    }
  end

  context 'with valid input' do
    it 'passes validation' do
      result = UserSchema.new.call(valid_input)
      expect(result.success?).to be(true)
      expect(result.errors.to_h).to be_empty
    end
  end

  context 'with invalid input' do
    it 'fails when first_name is missing' do
      input = valid_input.merge(first_name: nil)
      result = UserSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(first_name: ['must be filled'])
    end

    it 'fails when last_name is missing' do
      input = valid_input.merge(last_name: nil)
      result = UserSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(last_name: ['must be filled'])
    end

    it 'fails when email is missing' do
      input = valid_input.merge(email: nil)
      result = UserSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(email: ['must be filled'])
    end

    it 'fails when email is invalid' do
      input = valid_input.merge(email: 'invalid-email')
      result = UserSchema.new.call(input)

      expect(result.success?).to be(false)
      expect(result.errors.to_h).to include(email: ['is in invalid format'])
    end
  end
end
