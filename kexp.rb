require 'minitest/autorun'
require 'nokogiri'
require 'open-uri'
require 'JSON'
require 'fakeweb'

class KexpScraper

  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time   = end_time
  end

  def time_loop
    time = @start_time
    times = []
    begin
      times << time.strftime('%Y %-m %-d %l%P').split(' ')
    end while (time += 3600) <= @end_time
    times
  end

  def url_builder
    time_loop.map do |time|
      year, month, day, hour = time
      "http://kexp.org/playlist/#{year}/#{month}/#{day}/#{hour}"
    end
  end

  def playlist_and_dj_scraper(url)
    result = {}
    page = Nokogiri::HTML(open(url))

    result[:hosts] = show_host(page)
    result[:playlist_items] = playlist_items(page)

    result
  end

  def show_host(page)
    page.css('div.ShowHost').map { |div| div.text.strip }
  end

  def playlist_items(page)
    page.css('div[data-playlistitem]').map { |div| div['data-playlistitem'] }
  end

end

describe KexpScraper do

  before do
    FakeWeb.register_uri(:get,
                         "http://kexp.org/playlist/2014/7/6/12pm",
                         response: File.join(File.dirname(__FILE__),
                                             'spec',
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
