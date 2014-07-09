class DB

  attr_accessor :db, :collection

  def initialize(db, collection)
    @db = db
    @collection = collection
    connect
  end

  def connect
   mongo = Mongo::MongoClient.new("localhost", 27017)
   mongo.db(@db).collection(@collection)
  end

  # def self.server
  # end
  #
  # def self.database(name)
  #   server.db(name)
  # end

  # def self.collection(db_name, coll_name)
  #   database(db_name).collection(coll_name)
  # end
  # mongo = MongoClient.new("localhost", 27017)
  # kexp = mongo.db("kexp")
  # playlist = kexp.collection("playlist")

end
