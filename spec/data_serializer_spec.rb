require 'minitest/autorun'
require 'kexp'

describe DataSerializer do

  let(:file) { File.read('spec/fixtures/kexp_scraper_result') }
  let(:kexp_scraper_result) { JSON.parse(file) }

  it "creates new object with a blank result" do
    data = DataSerializer.new(kexp_scraper_result)
    data.result.must_equal Hash.new
  end
end

