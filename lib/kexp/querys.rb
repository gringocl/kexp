require 'mongo'

include Mongo

mongo = MongoClient.new("localhost", 27017)
kexp = mongo.db("kexp")
playlist = kexp.collection("playlist")

def grouping
  playlist.aggregate([
    { "$group" => {_id: { artist: "$ArtistName", track: "$TrackName" }}},
    { "$sort"  => {_id: -1}},
    { "$limit" => 1000}
    ],
    {allowDiskUse: true}
  )
end
