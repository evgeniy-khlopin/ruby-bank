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
class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :outgoing_transactions, class_name: 'BankTransaction', foreign_key: 'from_bank_account_id'
  has_many :incoming_transactions, class_name: 'BankTransaction', foreign_key: 'to_bank_account_id'

  def transactions
    (outgoing_transactions + incoming_transactions).sort_by(&:created_at)
  end
end
