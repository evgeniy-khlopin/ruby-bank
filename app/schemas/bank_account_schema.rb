class BankAccountSchema < ApplicationSchema
  params do
    required(:account_number).filled(:string)
    required(:currency).filled(:string)
    required(:balance).filled(:float)
  end

  rule(:balance) do
    key.failure('must be greater than or equal to 0') if value.negative?
  end
end
