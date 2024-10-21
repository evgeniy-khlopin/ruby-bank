# frozen_string_literal: true

module Transaction
  # Transaction::CreateTransactionService is responsible for creating a single transaction
  # for a given bank account. It updates the account balance based on the transaction type,
  # either increasing it for incoming transactions (e.g., credit, receive) or
  # decreasing it for outgoing transactions (e.g., transfer, withdrawal).
  # The service ensures that the transaction is atomic and the balance is checked
  # for outgoing transactions to prevent overdraft.ransaction
  class CreateTransactionService
    prepend SimpleCommand

    attr_reader :bank_account, :transaction_type, :amount, :bank_transaction

    def initialize(amount:, bank_account_id:, transaction_type:, target_bank_account_id: nil)
      @amount = amount
      @transaction_type = transaction_type
      @bank_account = BankAccount.find_by(id: bank_account_id)
      @bank_transaction = BankTransaction.new(transaction_type:, target_bank_account_id:)
    end

    def call
      bank_account.with_lock do
        check_balance
        update_bank_transaction!
        update_balance!
      end
      bank_transaction
    end

    private

    def check_balance
      # No need to check incoming transactions as they will not subtract from the balance
      return if bank_transaction.incoming?
      return if bank_account.balance >= amount

      error_message = "Account #{bank_account.account_number} has insufficient balance"
      errors.add(:base, error_message)
      raise ActiveRecord::Rollback, error_message
    end

    def update_balance!
      adjustment = bank_transaction.incoming? ? amount : -amount
      bank_account&.update!(balance: bank_account.balance + adjustment)
    end

    def update_bank_transaction!
      bank_transaction.assign_attributes(
        amount:,
        bank_account_id: bank_account.id,
        balance_before: bank_account.balance,
        transaction_number: SecureRandom.uuid
      )
      bank_transaction.save!
    end
  end
end
