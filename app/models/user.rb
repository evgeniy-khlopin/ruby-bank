class User < ApplicationRecord

  has_many :bank_accounts
  has_many :bank_transactions, through: :bank_accounts

  def full_name
    "#{first_name} #{last_name}"
  end
end
