class AddTargetBankAccountIdToBankTransactions < ActiveRecord::Migration[7.1]
  def change
    add_reference :bank_transactions, :target_bank_account, foreign_key: { to_table: :bank_accounts }, null: true
  end
end
