class User < ActiveRecord::Base
  def name
    [first_name, last_name].join(" ")
  end

  def picture(height = 254, width = 400)
    "https://graph.facebook.com/v2.1/#{uid}/picture?height=#{height}&width=#{width}"
  end

  def age
    now = DateTime.now
    bd = DateTime.strptime(birthday, "%m/%d/%Y")
    a = now.year - bd.year
    a = a - 1 if bd.month > now.month || (bd.month >= now.month && bd.day > now.day)
    a
  end

  def data
    OpenStruct.new(
      about: about || "There's nothing here",
      birthday: birthday ? "#{birthday} (#{age} years old)" : "There's nothing here",
      location: location || "There's nothing here"
    )
  end

  ###################### Matches ######################
  def wants(user)
    Match.exists?(user_uid: uid, match_uid: user.uid)
  end

  def matches(user)
    Match.exists?(
      user_uid: uid,
      match_uid: user.uid,
      mutual: true,
      response: true
    )
  end

  def match(user)
    Match.find_by(
      user_uid: uid,
      match_uid: user.uid,
      mutual: true,
      response: true
    )
  end

  def could_want?(user)
    return false if user.interested_in && gender && !user.interested_in.split(",").include?(gender)
    return false if interested_in && user.gender && !interested_in.split(",").include?(user.gender)
    true
  end

  def to_slide
    {
      "id" => uid,
      "caption" => name,
      "image_desktop" => picture,
      "type" => :user
    }
  end

  ###################### Class Methods ######################
  def self.update_or_create(auth)
    Like.update_all(auth.uid, auth.credentials)
    user = find_by(uid: auth.uid)
    if user
      user.update(user_params(auth))
    else
      user = create(user_params(auth))
    end
    user
  end

  def self.reset
    all.collect { |u| u.destroy unless u.id == 1 }
    moar
  end

  def self.moar
    require "open-uri"
    base = "https://graph.facebook.com/v2.1/"
    auth_url = URI.escape(base + "oauth/access_token?client_id=#{ENV["FACEBOOK_KEY"]}&client_secret=#{ENV["FACEBOOK_SECRET"]}&grant_type=client_credentials")

    # For some reason response is not JSON
    access_token = open(auth_url).read[/=.*/][1..-1]

    users_url = URI.escape(base + "#{ENV["FACEBOOK_KEY"]}/accounts/test-users?access_token=#{access_token}")
    users = JSON.parse(open(users_url).read)

    users["data"].each do |user|
      begin
        user_url = base + "#{user["id"]}?access_token=#{user["access_token"]}&fields=id,first_name,last_name,email,link,bio,gender,location,birthday,interested_in"
        user = JSON.parse(open(user_url).read)

        interested_in = user["interested_in"].join(",") if user["interested_in"]
        create(
          uid: user["id"],
          first_name: user["first_name"],
          last_name: user["last_name"],
          email: user["email"],
          link: user["link"],
          about: user["bio"],
          gender: user["gender"],
          interested_in: interested_in,
          location: user["location"].try(["name"]),
          birthday: user["birthday"]
        )
      end
    end
  end

  private
  def self.user_params(auth)
    interested_in = auth.extra.raw_info.interested_in.join(",") if auth.extra.raw_info.interested_in
    {
      uid: auth.uid,
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      link: auth.extra.raw_info.link,
      about: auth.extra.raw_info.bio,
      gender: auth.extra.raw_info.gender,
      interested_in: interested_in,
      location: auth.info.location,
      birthday: auth.extra.raw_info.birthday
    }
  end
end
