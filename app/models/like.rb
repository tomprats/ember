class Like < ActiveRecord::Base
  delegate :name, :about, :link, :picture, to: :page

  def page
    Page.find_by(uid: page_uid)
  end

  def self.update_all(uid, credentials)
    require "open-uri"

    where(user_uid: uid).destroy_all
    url = "https://graph.facebook.com/v2.1/#{uid}/likes?access_token=#{credentials.token}"
    parse_data(uid, credentials, url)
  rescue
    false
  end

  private
  def self.parse_data(uid, credentials, url)
    data = JSON.parse(open(url).read)
    data["data"].each do |like|
      create(
        page_uid: like["id"],
        user_uid: uid
      )
      Page.find_or_create(like["id"], credentials)
    end
    parse_data(uid, credentials, data["paging"]["next"]) if data["paging"]["next"]
  end
end
