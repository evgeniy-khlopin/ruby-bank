# == Schema Information
#
# Table name: bank_accounts
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  account_number :string           not null
#  balance        :decimal(15, 2)   default(0.0)
#  currency       :string           default("USD")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  describe '#generate_account_number' do
    let!(:user) { create(:user) }

    it 'generates a 16-digit account number before saving' do
      # Using create! because account number generated with before create callback
      bank_account = BankAccount.create!(user:, balance: 1000.0)
      expect(bank_account.account_number).to be_present
      expect(bank_account.account_number.length).to eq(16)
    end

    it 'generates a unique account number' do
      existing_account = BankAccount.create!(user:, balance: 1000.0)
      new_account = BankAccount.create!(user:, balance: 500.0)

      expect(new_account.account_number).to be_present
      expect(new_account.account_number).not_to eq(existing_account.account_number)
    end
  end
end
