module BankAccountsHelper
  def bank_accounts_select_options(bank_account)
    accounts = BankAccount.where.not(id: bank_account&.id)
    accounts.map do |account|
      ["#{format_account_number(account.account_number)} | #{account.user.full_name}", account.id]
    end
  end

  def user_bank_accounts_select_options
    current_user.bank_accounts&.map do |account|
      ["#{format_account_number(account.account_number)} | #{number_to_currency(account.balance)}", account.id]
    end
  end

  def format_account_number(account_number)
    account_number.chars.each_slice(4).map(&:join).join(' ')
  end
end
