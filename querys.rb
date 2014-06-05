require 'mongo'

include Mongo

mongo = MongoClient.new("localhost", 27017)
kexp = mongo.db("kexp")
playlist = kexp.collection("playlist")

puts playlist.aggregate([
  { "$group" =>
    {_id: "$ArtistName",
     TrackName: {"$addToSet" =>  "$TrackName" }, total_plays: {"$sum" => 1}}},
  { "$sort" => {total_plays: -1}},
  # { "$group" => {
                # _id: "$_id.ArtistName",
                # track: { "$_id.TrackName" => { "$sum" => 1 }}}},
  { "$limit" => 100 }
])
