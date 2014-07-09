class DataSerializer
  attr_accessor :hosts, :playlist_items, :result
  
  def initialize(kexp_scraper_result)
    @hosts = kexp_scraper_result[:hosts]
    @playlist_items = kexp_scraper_result[:playlist_items]
    @result = {}
  end

end
