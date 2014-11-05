class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    User.find_by(uid: session[:user_uid])
  end
  helper_method :current_user

  def authenticate_user!
    redirect_to root_path unless current_user
  end
  helper_method :authenticate_user!

  def new_notifications?
    Match.exists?(user_uid: current_user.uid, mutual: true, read: false)
  end
  helper_method :new_notifications?
end
