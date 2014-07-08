require 'forecast_io'
require 'dotenv'
require 'mongo'
require 'JSON'
require 'date'

include Mongo

mongo_client = MongoClient.new("localhost", 27017)
db = mongo_client.db("kexp")
coll = db.collection("weather")


Dotenv.load

ForecastIO.configure do |configuration|
  configuration.api_key = ENV['FORECAST']
end

lat  =  47.619075
long = -122.342835

dates = Date.new(2001,1,1)..Date.today

dates.each do |date|
  forecast = ForecastIO.forecast(lat, long, time: date.to_time.to_i)
  
  coll.insert(forecast)
  puts "added #{date.to_time}"

  forecast = nil

end
