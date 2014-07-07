require 'echowrap'
require 'dotenv'

def resolve_everything(id, results)
bucket = %w[ audio_summary artist_discovery artist_discovery_rank
               artist_familiarity artist_familiarity_rank artist_hotttnesss
               artist_hotttnesss_rank artist_location song_currency
               song_currency_rank song_discovery song_discovery_rank
               song_hotttnesss song_hotttnesss_rank song_type ]


  Dotenv.load

  Echowrap.configure do |c|
    c.api_key = ENV['ECHONEST_API_KEY']
    c.consumer_key = ENV['ECHONEST_CONSUMER_KEY']
    c.shared_secret = ENV['ECHONEST_SHARED_SECRET']
  end

  Echowrap.taste_profile_read(id: id, bucket: bucket, results: results)
end

