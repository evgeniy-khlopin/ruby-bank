class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :outgoing_transactions, class_name: 'BankTransaction', foreign_key: 'from_bank_account_id'
  has_many :incoming_transactions, class_name: 'BankTransaction', foreign_key: 'to_bank_account_id'

  def transactions
    (outgoing_transactions + incoming_transactions).sort_by(&:created_at)
  end
end
