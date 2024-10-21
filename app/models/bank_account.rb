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
  has_many :bank_transactions, dependent: :destroy

  before_validation :generate_account_number, on: :create

  private

  # TODO: investigate more efficient approach to generating account number
  def generate_account_number
    return if account_number.present?

    self.account_number = loop do
      generated_number = Array.new(16) { rand(0..9) }.join
      break generated_number unless BankAccount.exists?(account_number: generated_number)
    end
  end
end
