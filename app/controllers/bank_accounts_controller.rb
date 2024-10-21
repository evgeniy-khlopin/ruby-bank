class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  def show
    @bank_account = BankAccount.find(params[:id])
    @user = @bank_account.user
    respond_to(&:turbo_stream)
  end
end
