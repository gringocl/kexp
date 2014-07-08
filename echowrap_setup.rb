require 'dotenv'
require 'echowrap'

def load_echowrap
  Dotenv.load

  Echowrap.configure do |c|
    c.api_key = ENV['ECHONEST_API_KEY']
    c.consumer_key = ENV['ECHONEST_CONSUMER_KEY']
    c.shared_secret = ENV['ECHONEST_SHARED_SECRET']
  end
end


