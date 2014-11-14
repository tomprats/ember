class PersonalitiesController < ApplicationController
  def show
    @assessment_id = params[:id]
    @user = Assessment.find_by(uid: @assessment_id).user || User.new
  end
end
