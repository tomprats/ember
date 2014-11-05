class MatchingController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by(uid: params[:id])
    render json: { user: @user.data.to_h }
  end

  def index
    @slides = possible_matches.collect(&:to_slide)
  end

  def refresh
    render json: { slides: index, notification: new_notifications? }
  end

  def update
    match = Match.find_by(user_uid: params[:id], match_uid: current_user.uid, response: true)
    if match
      match.update_attributes(mutual: params[:response] == "true")
    end

    Match.find_or_create_by(
      user_uid: current_user.uid,
      match_uid: params[:id]
    ).update_attributes(response: params[:response], mutual: params[:response] == "true")

    render json: { status: 200, notification: new_notifications? }
  end

  private
  def possible_matches
    users = User.all.select { |u| u != current_user && current_user.could_want?(u) && !current_user.wants(u) }.first(50).shuffle
    if users.empty?
      users = User.all.select { |u| u != current_user && current_user.could_want?(u) }.first(50).shuffle
    end
    users
  end
end
