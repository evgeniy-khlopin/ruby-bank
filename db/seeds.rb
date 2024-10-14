bank_accounts = []
10.times.map do
  user = FactoryBot.create(:user)
  bank_accounts << FactoryBot.create(:bank_account, user: user, currency: 'USD')
end

20.times do
  from_bank_account = bank_accounts.sample
  to_bank_account = bank_accounts.sample

  next if from_bank_account == to_bank_account

  FactoryBot.create(
    :bank_transaction,
    from_bank_account: from_bank_account,
    to_bank_account: to_bank_account,
    balance_before: from_bank_account.balance,
    balance_after: from_bank_account.balance + rand(100..500)
  )
end