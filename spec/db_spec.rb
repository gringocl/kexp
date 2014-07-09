require 'minitest/autorun'
require 'kexp'

describe DB do

  it "creates connection when new object is created" do
    database = DB.new("kexp", "kexp_test")
    database.collection.must_equal "kexp_test"
    database.db.must_equal "kexp"

    

  end

end
