def change_times(collection)
  collection.find.each do |doc|
    airdate = doc["AirDate"]
    begin
      date = airdate.scan(/\d+/).first.to_i
      new_date = Time.at(date.to_i/1000.0)

      collection.update({"_id" => doc["_id"]}, {"$set" => {"AirDate" => new_date}})
    rescue NoMethodError => e
      File.open('errors.txt', 'a') { |f| puts doc["_id"] }
      next
    end
  end
end

def change_times_weather(weather)
  weather.find.each do |doc|
    current_time = doc["currently"]["time"]

    utc_time = Time.at(current_time)

    weather.update({"_id" => doc["_id"]}, {"$set" => {"currently.time" => utc_time}})

  end
end

def format_string_epoch_date_to_iso_date(string_date)
  int_date = string_date.scan(/\d+/).first.to_i
  Time.at(date.to_i/1000.0)
end

