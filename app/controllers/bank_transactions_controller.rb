class BankTransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    from_bank_account_id = params[:from_bank_account_id]
    to_bank_account_id = params[:to_bank_account_id]
    amount = params[:amount].to_d

    result = Transaction::TransferService.call(
      from_bank_account_id:,
      to_bank_account_id:,
      amount:
    )

    if result.success?
      @bank_account = BankAccount.find(from_bank_account_id)
      @user = @bank_account.user

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, notice: 'Transfer completed successfully.' }
      end
    else
      redirect_to root_path, alert: "Transfer failed: #{result.errors.full_messages.join(', ')}"
    end
  end
end
