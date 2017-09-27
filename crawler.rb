require "nokogiri"
require "open-uri"

class Crawler
  BASE_URL = "https://finshop.belgium.be"

  def self.search(keyword)
    result_page = Nokogiri::HTML(open(result_url(keyword)))
    result_elements = result_page.css(".views-field-title")
    result_elements.inject([]) do |memo, element|
      url = detail_url(element)
      detail_page = Nokogiri::HTML(open(url))
      memo << {
        title: element.text.strip,
        url: url,
        price: price(detail_page),
        available: available?(detail_page)
      }
    end
  end

  def self.result_url(keyword)
    BASE_URL + "/nl/search?search_api_views_fulltext=" + keyword
  end

  def self.detail_url(result_element)
    BASE_URL + result_element.search("a").first.attributes["href"].value
  end

  def self.price(detail_page)
    detail_page.css(".cart .price").text.to_f
  end

  def self.available?(detail_page)
    button = detail_page.css("#edit-submit").first
    button.attributes["disabled"]&.value&.downcase != "disabled"
  end
end
