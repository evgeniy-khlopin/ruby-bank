# frozen_string_literal: true

bank_accounts = []
10.times.map do
  user = FactoryBot.create(:user)
  bank_accounts << FactoryBot.create(:bank_account, user:, currency: 'USD')
end
