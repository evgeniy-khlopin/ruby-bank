class CreateBankAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :account_number, null: false
      t.decimal :balance, precision: 15, scale: 2, default: 0.0
      t.string :currency, default: 'USD'

      t.timestamps
    end

    # Add a unique index for account_number
    add_index :bank_accounts, :account_number, unique: true
  end
end
