require 'minitest/autorun'
require 'kexp'
require 'fakeweb'

describe KexpScraper do

  before do
    FakeWeb.allow_net_connect = false
    FakeWeb.register_uri(:get, "http://kexp.org/playlist/2014/7/6/12pm",
                         response: File.join(File.dirname(__FILE__),
                                             'fixtures',
                                             'playlist.html'))
  end

  let(:kexp_scraper) { KexpScraper.new(Time.new(2014, 7, 6, 12), Time.new(2014, 7, 6, 13)) }

  it "#time_loop returns array of year, month, day, and 12hr am/pm" do
    result = kexp_scraper.time_loop

    result[0].must_equal ["2014", "7", "6", "12pm"]
    result[1].must_equal ["2014", "7", "6", "1pm"]
  end

  it "#url_builder returns array of strings(uri) for each time loop" do
    result = kexp_scraper.url_builder

    result[0].must_equal "http://kexp.org/playlist/2014/7/6/12pm"
    result[1].must_equal "http://kexp.org/playlist/2014/7/6/1pm"
  end

  it "#playlist_and_dj_scraper returns times' playlist_items and current dj" do
    result = kexp_scraper.playlist_and_dj_scraper("http://kexp.org/playlist/2014/7/6/12pm")

    result[:hosts].must_include "Stevie Zoom"
    result[:playlist_items].to_json.must_match /The Ruby Suns/

  end
end
