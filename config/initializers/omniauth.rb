Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV["FACEBOOK_KEY"], ENV["FACEBOOK_SECRET"],
    scope: "email, user_likes, user_birthday, user_friends, user_location, user_about_me, user_relationship_details"
end
