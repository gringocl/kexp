require 'nokogiri'
require 'open-uri'
require 'mongo'
require 'JSON'

include Mongo

mongo_client = MongoClient.new("localhost", 27017)
db = mongo_client.db("kexp")
coll = db.collection("playlist")

dates = Date.new(2001,2,2)..Date.today
times = %w[1am, 2am, 3am, 4am, 5am, 6am, 7am, 8am, 9am, 10am, 11am, 12pm,
          1pm, 2pm, 3pm, 4pm, 5pm, 6pm, 7pm, 8pm, 9pm, 10pm, 11pm, 12am]
dates.each do |date|
  times.each do |time|
    doc = Nokogiri::HTML(open("http://kexp.org/playlist/#{date.strftime('%Y')}/#{date.strftime('%-m')}/#{date.strftime('%-d')}/#{time}"))

    doc.css('div[data-playlistitem]').each do |div|
      playlistitem = JSON.parse div['data-playlistitem']

      coll.insert(playlistitem)
      puts "insertion complete..."
    end
    puts "Finish #{date} and #{time}"
  end
  puts "Completed #{date}"
end
puts "Completed all dates"


# DateTime.strptime(date, '%Q') # no timezone
# airdate.scan(/\d+/).first
