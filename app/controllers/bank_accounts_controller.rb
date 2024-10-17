class BankAccountsController < ApplicationController
  def show
    @bank_account = BankAccount.find(params[:id])
    @user = @bank_account.user
    respond_to(&:turbo_stream)
  end
end
