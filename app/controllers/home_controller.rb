class HomeController < ApplicationController
  def index
    @user = User.includes(bank_accounts: %i[incoming_transactions outgoing_transactions]).find(123)
  end
end
