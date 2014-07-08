require 'minitest/autorun'
require 'nokogiri'
require 'open-uri'
require 'mongo'
require 'JSON'

include Mongo

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
    #     begin
    #       year, month, day = date.strftime('%F').split("-")
    #       url = "http://kexp.org/playlist/#{year}/#{month}/#{day}/#{time}"
    #       doc = Nokogiri::HTML(open(url))
    #
    #       doc.css('div[data-playlistitem]').each do |div|
    #         playlistitem = JSON.parse div['data-playlistitem']
    #         coll.insert(playlistitem)
    #         puts "insertion complete..."
    #         playlistitem = nil
    #       end
    #
    #       doc = nil
    #       puts "Finished #{date} and #{time}"
    #     rescue Timeout::Error
    #       puts "The request for #{url} page has timed out"
    #       next
    #     rescue OpenURI::HTTPError => e
    #       puts "The request for #{url}, returned an error. #{e.message}"
    #       next
    #     end
    #   end
    #   puts "Completed #{date}"
    # end
    # puts "Completed all dates"

end

describe KexpScraper do

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



end
