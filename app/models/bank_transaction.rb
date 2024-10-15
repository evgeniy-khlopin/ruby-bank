# == Schema Information
#
# Table name: bank_transactions
#
#  id                   :integer          not null, primary key
#  details              :string
#  transaction_type     :integer
#  transaction_number   :string
#  amount               :decimal(15, 2)   default(0.0)
#  balance_before       :decimal(15, 2)   default(0.0)
#  bank_account_id      :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class BankTransaction < ApplicationRecord
  belongs_to :bank_account

  before_validation :generate_transaction_number, on: :create

  enum transaction_type: { credit: 0, debit: 1, transfer: 2, withdrawal: 3, receive: 4 }

  def outgoing?
    transfer? || withdrawal?
  end

  def incoming?
    credit? || debit? || receive?
  end

  private

  def generate_transaction_number
    self.transaction_number = SecureRandom.uuid
  end
end
