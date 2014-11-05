class SessionsController < ApplicationController
  def new
    redirect_to matching_index_path if current_user
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.update_or_create(auth)
    session[:user_uid] = user.uid

    redirect_to matching_index_path
  end

  def destroy
    session[:user_uid] = nil
    redirect_to root_path
  end
end
