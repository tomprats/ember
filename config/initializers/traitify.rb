Traitify.configure do |config|
  config.api_host = ENV["TRAITIFY_HOST"]
  config.api_version = "v1"
  config.secret = ENV["TRAITIFY_SECRET"]
end
