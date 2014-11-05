class Match < ActiveRecord::Base
  def inverse
    Match.find_by(user_uid: match_uid, match_uid: user_uid)
  end

  def match
    User.find_by(uid: match_uid)
  end

  def mutual_interests
    user_likes = Like.where(user_uid: user_uid).select(:page_uid)
    mutual_likes = Like.where(user_uid: match_uid, page_uid: user_likes.collect(&:page_uid)).select(:page_uid)
    Page.where(uid: mutual_likes.collect(&:page_uid))
  end
end
