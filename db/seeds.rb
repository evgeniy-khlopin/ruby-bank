10.times.map do
  user = FactoryBot.create(:user)
  FactoryBot.create(:bank_account, user: user, currency: 'USD')
end
