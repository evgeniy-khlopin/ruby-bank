class CreateBankTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_transactions do |t|
      t.string :details
      t.integer :transaction_type
      t.string :transaction_number
      t.decimal :amount, precision: 15, scale: 2, default: 0.0
      t.decimal :balance_after, precision: 15, scale: 2, default: 0.0
      t.decimal :balance_before, precision: 15, scale: 2, default: 0.0
      t.references :from_bank_account, foreign_key: { to_table: :bank_accounts }
      t.references :to_bank_account, foreign_key: { to_table: :bank_accounts }

      t.timestamps
    end

    add_index :bank_transactions, :transaction_number, unique: true
  end
end
