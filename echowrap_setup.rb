require 'dotenv'
require 'echowrap'

  Dotenv.load

  Echowrap.configure do |c|
    c.api_key = ENV['ECHONEST_API_KEY']
    c.consumer_key = ENV['ECHONEST_CONSUMER_KEY']
    c.shared_secret = ENV['ECHONEST_SHARED_SECRET']
  end

  name = "#{collection.name} year #{year} - #{rand(100)}"
  taste_profile = Echowrap.taste_profile_create(name: name, type: "general")
  taste_update  = Echowrap.taste_profile_update(id: taste_profile.id, data: data.to_json)
