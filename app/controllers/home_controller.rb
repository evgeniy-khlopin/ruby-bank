class HomeController < ApplicationController
  def index
    @user = User.includes(bank_accounts: :bank_transactions).find(52)
    @bank_account = @user.bank_accounts.first
  end
end
