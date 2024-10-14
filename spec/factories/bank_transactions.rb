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
FactoryBot.define do
  factory :bank_transaction do
    transaction_number { SecureRandom.uuid }
    association :from_bank_account, factory: :bank_account, strategy: :build
    association :to_bank_account, factory: :bank_account, strategy: :build
    amount { rand(10..1000).to_f }
    transaction_type { BankTransaction.transaction_types.values.sample }
    balance_before { rand(500..1000).to_f }
    balance_after { balance_before + amount }
    details { Faker::Lorem.sentence }
  end
end
