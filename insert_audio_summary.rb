require 'echowrap'
require 'mongo'

require 'pry'
load 'echowrap_setup.rb'

include Mongo

def update_mongo

  load_echowrap

  profiles = Echowrap.taste_profile_list

  ids = profiles.map { |profile| profile.id }

  mongo = MongoClient.new
  playlist = mongo.db("kexp").collection("playlist")

  ids.each do |id|
    total_items = Echowrap.taste_profile_profile(id: id).total
    times = (total_items/1000) + 1

    start = 1
    bucket = %w[ audio_summary artist_discovery artist_discovery_rank
                 artist_familiarity artist_familiarity_rank artist_hotttnesss
                 artist_hotttnesss_rank artist_location song_currency
                 song_currency_rank song_discovery song_discovery_rank
                 song_hotttnesss song_hotttnesss_rank song_type ]

    times.times do
      items = Echowrap.taste_profile_read(id: id, start: start, results: 1000, bucket: bucket).items
      items.each do |item|
        audio_summary = item.audio_summary.attrs

        if audio_summary != nil
          audio_summary.delete(:analysis_url)
          audio_summary.delete(:audio_md5)

          update = { "AudioSummary" => audio_summary,
                     "ArtistId" => item.artist_id,
                     "ArtistLocation" => item.artist_location.attrs,
                     "SongId" => item.song_id }

          mongo_id = item.request.item_id
          bson_id = BSON::ObjectId.from_string(mongo_id)

          playlist.update({"_id" => bson_id}, {"$set" => update})
          start += 999
        else
          puts "#{item}"
          start += 999
        end
      end
      puts "finished - #{start}"
    end
  end
end
