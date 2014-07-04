years = 2001..2014
years.each do |year|
  start_date = Time.local(year).utc
  end_date  = Time.local(year+1).utc

  playlist.find({ "AirDate"    => { "$gte" => start_date, "$lt" => end_date },
                  "ArtistName" => { "$ne"  => null }})
end
