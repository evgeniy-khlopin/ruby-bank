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