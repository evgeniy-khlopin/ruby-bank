# == Schema Information
#
# Table name: bank_transactions
#
#  id                     :integer          not null, primary key
#  details                :string
#  transaction_type       :integer
#  transaction_number     :string
#  amount                 :decimal(15, 2)   default(0.0)
#  balance_before         :decimal(15, 2)   default(0.0)
#  bank_account_id        :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  target_bank_account_id :integer
#
require "test_helper"

class BankTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
