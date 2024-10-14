# == Schema Information
#
# Table name: bank_transactions
#
#  id                   :integer          not null, primary key
#  details              :string
#  transaction_type     :integer
#  transaction_number   :string
#  amount               :decimal(15, 2)   default(0.0)
#  balance_after        :decimal(15, 2)   default(0.0)
#  balance_before       :decimal(15, 2)   default(0.0)
#  from_bank_account_id :integer
#  to_bank_account_id   :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class BankTransaction < ApplicationRecord
  belongs_to :from_bank_account, class_name: 'BankAccount'
  belongs_to :to_bank_account, class_name: 'BankAccount'

  before_create :generate_transaction_number

  enum transaction_type: { transfer: 0, deposit: 1, withdrawal: 2, credit: 3 }

  validates :transaction_number, uniqueness: true

  private

  def generate_transaction_number
    self.transaction_number = SecureRandom.uuid
  end
end
