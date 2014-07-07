require 'json'
require 'echowrap'
require 'pry'
require 'dotenv'

def yearly(collection, years)
  years.each do |year|
    start_date = Time.local(year).utc
    end_date   = Time.local(year+1).utc
    data = []
    query      = { "AirDate"    => { "$gte" => start_date,
                                     "$lt"  => end_date },
                   "ArtistName" => { "$ne"  => nil },
                   "TrackName"  => { "$ne"  => nil }}

    collection.find(query).each do |doc|
      id = doc["_id"].to_s
      artist = doc["ArtistName"]
      track = doc["TrackName"]
      taste_object = { "item" => { "item_id"     => id,
                                   "artist_name" => artist,
                                   "song_name"   => track } }
      data << taste_object
    end

    # Dotenv.load
    #
    # Echowrap.configure do |c|
    #   c.api_key = ENV['ECHONEST_API_KEY']
    #   c.consumer_key = ENV['ECHONEST_CONSUMER_KEY']
    #   c.shared_secret = ENV['ECHONEST_SHARED_SECRET']
    # end
    #
    # name = "#{collection.name} year #{year} - #{rand(100)}"
    # taste_profile = Echowrap.taste_profile_create(name: name, type: "general")
    # taste_update  = Echowrap.taste_profile_update(id: taste_profile.id, data: data.to_json)

    file = File.open("#{year}.json", "w")
    file.write(data.to_json)
    file.close

    puts "#{year} complete!"

  end

end
