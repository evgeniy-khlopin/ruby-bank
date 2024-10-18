class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid email or password'
      render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
