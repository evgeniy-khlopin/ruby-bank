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
