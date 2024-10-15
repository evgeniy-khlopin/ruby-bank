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
      ActiveRecord::Base.transaction do
        create_transaction(from_bank_account_id, :transfer)
        create_transaction(to_bank_account_id, :receive)
      end
    end

    private

    def create_transaction(bank_account_id, transaction_type)
      result = CreateTransactionService.call(amount:, bank_account_id:, transaction_type:)

      fail!(result.errors.full_messages) unless result.success?
    end

    def fail!(messages)
      errors.add(:base, "Transaction failed: #{messages.join(', ')}")
      raise ActiveRecord::Rollback
    end
  end
end
