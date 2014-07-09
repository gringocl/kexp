class Mongo

  def server
    Mongo::MongoClient.new("localhost", 27017)
  end

  # mongo = MongoClient.new("localhost", 27017)
  # kexp = mongo.db("kexp")
  # playlist = kexp.collection("playlist")

end


