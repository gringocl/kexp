years = 2001..2014
years.each do |year|
  start_date = Time.local(year).utc
  end_date   = Time.local(year+1).utc

  query      = { "AirDate"    => { "$gte" => start_date,
                                   "$lt" => end_date },
                 "ArtistName" => { "$ne"  => null }}

  playlist.find(query).each do |doc|
    id = doc["_id"].to_s
    artist = doc["ArtistName"]
    track = doc["TrackName"]
    taste_object = { "item_id" => id,
                     "artist_name" => artist,
                     "song_name" => track }
  end
end
