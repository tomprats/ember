class MatchingController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by(uid: params[:id])
    render json: { user: @user.data.to_h }
  end

  def index
#    people
#    assessment
    both
  end

  def refresh
    render json: { slides: index, notification: new_notifications? }
  end

  def people
    @slides = possible_matches.collect(&:to_slide).first(50)
  end

  def assessment
    @assessment_id = current_user.incomplete_assessment.uid
  end

  def both
    assessment = current_user.incomplete_assessment
    assessment_slides = assessment.slides
    if assessment_slides.empty?
      assessment = current_user.incomplete_assessment
      assessment_slides = assessment.slides
    end
    @slides = interleave(possible_matches.collect(&:to_slide), assessment_slides).first(50)
  rescue
    @slides = possible_matches.collect(&:to_slide).first(50)
  end

  def update
    if params[:type] == "user"
      match = Match.find_by(user_uid: params[:id], match_uid: current_user.uid, response: true)
      if match
        match.update_attributes(mutual: params[:response] == "true")
      end

      Match.find_or_create_by(
        user_uid: current_user.uid,
        match_uid: params[:id]
      ).update_attributes(response: params[:response], mutual: params[:response] == "true")
    else
      traitify.update_slide(params[:assessment_id], {
        id: params[:id],
        response: params[:response],
        time_taken: 200
      })
    end

    render json: { status: 200, notification: new_notifications? }
  end

  private
  def interleave(a, b)
    a.length >= b.length ? a.zip(b).flatten.compact : b.zip(a).flatten.compact
  end

  def possible_matches
    users = User.all.select { |u| u != current_user && current_user.could_want?(u) && !current_user.wants(u) }.shuffle
    if users.empty?
      users = User.all.select { |u| u != current_user && current_user.could_want?(u) }.shuffle
    end
    users
  end
end
