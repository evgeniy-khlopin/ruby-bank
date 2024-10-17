class BankTransactionSchema < ApplicationSchema
  params do
    required(:transaction_number).filled(:string)
    required(:transaction_type).filled(:string)
    required(:amount).filled(:decimal)
    required(:balance_before).filled(:decimal)
    required(:bank_account_id).filled(:integer)
    optional(:target_bank_account_id).maybe(:integer)
    optional(:details).maybe(:string)
  end

  # Allow only values specified in the transaction_types enum
  rule(:transaction_type) do
    allowed_types = BankTransaction.transaction_types
    key.failure('is not a valid transaction type') unless allowed_types.key?(value.to_sym)
  end

  rule(:amount) do
    key.failure('must be greater than 0') unless value.positive?
  end


  rule(:balance_before) do
    key.failure('must be greater than or equal to 0') if value.negative?
  end
end
