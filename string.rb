require 'mongo'

include Mongo

mongo = MongoClient.new("localhost", 27017)
kexp = mongo.db("kexp")
playlist = kexp.collection("playlist")

def find_ascii_only(collection, key)
  @array = []
  collection.find.each do |doc|
    if doc[key] != nil
      string = doc[key]
      @array << doc["_id"] unless string.ascii_only?
    end
  end
end

def remove_windows_funk(collection, field)
  funk = collection.find({ field => /â€™/}).to_a
  funk.each do |f|
    string = f[field]
    new_string = str.gsub("â€™", "'")
    collection.update({"_id" => f['_id']}, {"$set" => {field => new_string}})
  end
end

def fix_encoding(array_of_ids, collection, key, encoding)
  array_of_ids.each do |ids|
    doc = collection.find_one({"_id" => ids })
    string = doc[key]
    begin
      new_string = string.encode(encoding).force_encoding("utf-8")
      collection.update({"_id" => doc["_id"]}, {"$set" => {key => new_string}})
    rescue
      File.open('errors.txt', 'a') { |f| puts doc["_id"] }
      next
    end
  end
end
