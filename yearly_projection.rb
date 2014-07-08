require 'json'
require 'echowrap'
require 'pry'
require 'dotenv'

def yearly(collection, years)
    Dotenv.load

    Echowrap.configure do |c|
      c.api_key = ENV['ECHONEST_API_KEY']
      c.consumer_key = ENV['ECHONEST_CONSUMER_KEY']
      c.shared_secret = ENV['ECHONEST_SHARED_SECRET']
    end

  years.each do |year|

    name = "#{collection.name} year #{year} - #{rand(100)}"
    taste_profile = Echowrap.taste_profile_create(name: name, type: "general")

    start_date = Time.local(year).utc
    end_date   = Time.local(year+1).utc
    query      = { "AirDate"    => { "$gte" => start_date,
                                     "$lt"  => end_date },
                   "ArtistName" => { "$ne"  => nil },
                   "TrackName"  => { "$ne"  => nil }}

    count = 1

    collection.find(query).each_slice(1000) do |doc_slice|

      new_name = "#{collection.name} year #{year} - continued}"
      new_taste_profile = Echowrap.taste_profile_create(name: new_name, type: "general")
      count >= 99 ? taste_id = new_taste_profile.id : taste_id = taste_profile.id

      data = []
      doc_slice.each do |doc|
        id = doc["_id"].to_s
        artist = doc["ArtistName"]
        track = doc["TrackName"]
        taste_object = { "item" => { "item_id"     => id,
                                     "artist_name" => artist,
                                     "song_name"   => track } }
        data << taste_object
      end
    puts "updating profile"

    begin
      taste_update  = Echowrap.taste_profile_update(id: taste_id, data: data.to_json)

      puts "#{taste_update.ticket} -##{count}"
      count += 1
    rescue Net::ReadTimeout
      puts "There has been a timeout error, retrying"
      retry
    rescue Echowrap::Error::ClientError
      puts "There has been an error, retrying"
      retry
    end

    end



    # file = File.open("#{year}.json", "w")
    # file.write(data.to_json)
    # file.close

    puts "#{year} complete!"

  end

end
