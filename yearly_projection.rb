require 'json'
require 'echowrap'
require 'pry'

def yearly(collection, years)
  ticket_numbers = ""

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
    name = "#{collection.name} year #{year} - #{rand(100)}"
    taste_profile = Echowrap.taste_profile_create(name: name, type: "general")
    taste_update  = Echowrap.taste_profile_update(id: taste_profile.id, data: data.to_json)

    ticket_numbers << taste_update.ticket
  end

  file = File.open('tickets.txt', 'w')
  file.write(ticket_numbers)
  file.close
end
