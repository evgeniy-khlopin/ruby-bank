# frozen_string_literal: true

module Transaction
  # Transaction::TransferService handles the transfer of funds between two bank accounts.
  # It creates both an outgoing transaction from the sender's account and an incoming transaction
  # to the recipient's account. The entire operation is wrapped in a database transaction
  # to ensure atomicity, meaning both transactions will either succeed or be rolled back
  # in case of any errors.
  class TransferService
    prepend SimpleCommand

    attr_reader :from_bank_account_id, :to_bank_account_id, :amount

    def initialize(from_bank_account_id:, to_bank_account_id:, amount:)
      @amount = amount
      @to_bank_account_id = to_bank_account_id
      @from_bank_account_id = from_bank_account_id
    end

    def call
      return fail!(["can't transfer to the same account"]) if from_bank_account_id == to_bank_account_id
      return fail!(['amount shuold be positive']) if amount <= 0

      ActiveRecord::Base.transaction do
        create_transaction(from_bank_account_id, :transfer, to_bank_account_id)
        create_transaction(to_bank_account_id, :receive, from_bank_account_id)
      end
    end

    private

    def create_transaction(bank_account_id, transaction_type, target_bank_account_id = nil)
      result = CreateTransactionService.call(amount:, bank_account_id:, transaction_type:, target_bank_account_id:)

      fail!(result.errors.full_messages) if result.failure?
    end

    def fail!(messages)
      error_messages = "Transaction failed: #{messages.join(', ')}"
      errors.add(:base, error_messages)
      raise ActiveRecord::Rollback, error_messages
    end
  end
end
