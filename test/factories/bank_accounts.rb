FactoryBot.define do
  factory :bank_account do
    association :user
    account_number { Faker::Finance.credit_card(:mastercard, :visa).delete('-') }
    balance { rand(0..1000).to_f }
    currency { 'USD' }
  end
end
