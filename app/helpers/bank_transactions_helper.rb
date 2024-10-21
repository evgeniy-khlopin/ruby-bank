module BankTransactionsHelper
  def transaction_class(transaction)
    transaction.incoming? ? 'text-green-800' : 'text-red-800'
  end

  def amount(transaction)
    transaction.incoming? ? "+#{transaction.amount}" : "-#{transaction.amount}"
  end

  def target_user_name(transaction)
    transaction.target_bank_account&.user&.full_name || 'Bank credit'
  end

  def transactions_list(bank_account)
    return [] if bank_account.blank?

    bank_account.bank_transactions&.reverse
  end

  def transaction_time(transaction)
    transaction.created_at.strftime('%d %b %Y, %H:%M')
  end
end
