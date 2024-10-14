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
  describe '#transactions' do
    let(:bank_account) { create(:bank_account) }
    let(:other_account) { create(:bank_account) }

    let!(:incoming_transaction1) { create(:bank_transaction, to_bank_account: bank_account, created_at: 1.day.ago) }
    let!(:incoming_transaction2) { create(:bank_transaction, to_bank_account: bank_account, created_at: 2.days.ago) }
    let!(:outgoing_transaction1) { create(:bank_transaction, from_bank_account: bank_account, created_at: 3.days.ago) }
    let!(:outgoing_transaction2) { create(:bank_transaction, from_bank_account: bank_account, created_at: 4.days.ago) }

    it 'returns all transactions sorted by created_at' do
      transactions = bank_account.transactions

      expect(transactions).to eq([outgoing_transaction2, outgoing_transaction1, incoming_transaction2, incoming_transaction1])
    end

    it 'returns an empty array if there are no transactions' do
      empty_account = create(:bank_account)
      expect(empty_account.transactions).to be_empty
    end
  end
end
