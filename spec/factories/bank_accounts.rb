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
FactoryBot.define do
  factory :bank_account do
    association :user
    account_number { Faker::Finance.credit_card(:mastercard, :visa).delete('-') }
    balance { rand(0..1000).to_f }
    currency { 'USD' }
  end
end
