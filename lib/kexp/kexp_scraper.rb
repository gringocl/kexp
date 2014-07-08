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

