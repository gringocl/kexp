def search_weather_for_playlist_date(playlist_doc, weather_collection)
  weather_collection.find_one({ "currently.time" => { "$eq" => playlist_date_at_zero_hours(playlist_doc)}})
end

def playlist_date_at_zero_hours(playlist_doc)
  time = playlist_doc["AirDate"]
  Time.local(time.year, time.month, time.day).utc
end

def playlist_local_time(playlist_doc)
  playlist_doc["AirDate"].getlocal
end

def playlist_hour(playlist_doc)
  playlist_local_time(playlist_doc).hour
end

def hourly_weather_doc(weather_doc, playlist_doc)
  weather_doc["hourly"]["data"][playlist_hour(playlist_doc)]
end

def insert_weather_into_playlist_doc(playlist_collection, playlist_doc, weather_doc)
  playlist_collection.update({"_id"  => playlist_doc["_id"]},
                    {"$set" => {"WeatherInfo" => hourly_weather_doc(weather_doc, playlist_doc) }})
end

def find_and_add_weather(playlist_collection, weather_collection)
  playlist_collection.find.each do |playlist_doc|
    weather_doc = search_weather_for_playlist_date(playlist_doc, weather_collection)
    insert_weather_into_playlist_doc(playlist_collection, playlist_doc, weather_doc)
  end
end
