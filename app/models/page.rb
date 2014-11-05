class Page < ActiveRecord::Base
  def picture(height = 200, width = 200)
    "https://graph.facebook.com/v2.1/#{uid}/picture?height=#{height}&width=#{width}"
  end

  def self.find_or_create(uid, credentials)
    return true if find_by(uid: uid)

    require "open-uri"
    url = "https://graph.facebook.com/v2.1/#{uid}?access_token=#{credentials.token}"
    page = JSON.parse(open(url).read)

    create(
      uid: uid,
      name: page["name"],
      link: page["link"],
      about: page["about"]
    )
  rescue
    false
  end
end
