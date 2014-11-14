class Assessment < ActiveRecord::Base
  def user
    User.find_by(uid: user_uid)
  end

  def slides
    incomplete = Traitify.new.find_slides(uid).collect do |slide|
      unless slide.completed_at
        slide.assessment_id = uid
        slide
      end
    end.compact

    update_results if incomplete.empty?

    incomplete
  end

  def update_results
    results = Traitify.new.results(uid)
    personality_type = results.personality_types[0].personality_type
    update_attributes(
      completed: true,
      personality_type: personality_type.name,
      badge: personality_type.badge.image_medium
    )
  end
end
