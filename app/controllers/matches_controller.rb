class MatchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @matches = Match.where(user_uid: current_user.uid, mutual: true).order(read: :asc, updated_at: :desc)
  end

  def show
    @user = User.find_by(uid: params[:id])
    @match = current_user.match(@user)
    if @match
      @match.update_attributes(read: true)
      @mutual_interests = @match.mutual_interests
      @data = @user.data
    elsif @user == current_user
      @mutual_interests = Page.where(uid: Like.where(user_uid: @user.uid).select(:page_uid).collect(&:page_uid))
      @data = @user.data
    else
      redirect_to matches_path
    end
  end
end
