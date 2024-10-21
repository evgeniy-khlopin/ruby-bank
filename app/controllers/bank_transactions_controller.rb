class BankTransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    result = transfer_funds

    if result.success?
      handle_success_response
    else
      handle_error_response(result)
    end
  end

  private

  def transfer_funds
    from_bank_account_id = params[:from_bank_account_id]
    to_bank_account_id = params[:to_bank_account_id]
    amount = params[:amount].to_d

    Transaction::TransferService.call(
      from_bank_account_id:,
      to_bank_account_id:,
      amount:
    )
  end

  def handle_success_response
    @bank_account = BankAccount.find(params[:from_bank_account_id])
    @user = @bank_account.user

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = 'Transfer completed successfully' }
    end
  end

  def handle_error_response(result)
    respond_to do |format|
      format.turbo_stream do
        flash.now[:error] = result.errors[:base]&.first
        render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash')
      end
    end
  end
end
