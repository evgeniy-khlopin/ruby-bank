class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @bank_account = @user.bank_accounts.first
  end
end
