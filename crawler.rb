require "open-uri"
require "rexml/document"

class Crawler
  include REXML

  BASE_URL = "https://finshop.belgium.be"

  attr_reader :data

  def self.search(keyword)
    require_relative "./results_crawler"
    require_relative "./detail_crawler"

    results_crawler = ResultsCrawler.new(keyword)
    results_crawler.fetch_and_parse
    results_data = results_crawler.data
    results_data.inject([]) do |memo, result_data|
      detail_crawler = DetailCrawler.new(result_data[:url])
      detail_crawler.fetch_and_parse
      detail_data = detail_crawler.data
      memo << {
        title:     result_data[:title],
        url:       result_data[:url],
        price:     detail_data[:price],
        available: detail_data[:available]
      }
    end
  end

  def fetch_and_parse
    open(@url).each_line do |line|
      parse_line(line.strip)
    end
  end
end
