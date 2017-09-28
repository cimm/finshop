require "rexml/document"
require "open-uri"

class Crawler
  include REXML

  BASE_URL = "https://finshop.belgium.be"

  def self.search(keyword)
    result_page = fetch_result_page(keyword)
    result_nodes = result_page.get_elements("//*[contains(@class, 'views-field-title')]/span/a")
    result_nodes.inject([]) do |memo, node|
      url = detail_url(node)
      details = fetch_detail_page(url)
      memo << {
        title: child_text(node),
        url: url,
        price: details[:price],
        available: details[:available]
      }
    end
  end

  def self.result_url(keyword)
    BASE_URL + "/nl/search?search_api_views_fulltext=" + keyword
  end

  def self.detail_url(result_node)
    BASE_URL + result_node.attributes["href"]
  end

  def self.fetch_result_page(keyword)
    body = ""
    open(result_url(keyword)) do |f|
      f.each_line.with_index do |line, index|
        next unless index.between?(76, 369)
        next if line.strip.start_with?("<img")
        body += line
      end
    end
    Document.new(body + "</body>")
  end

  def self.fetch_detail_page(url)
    details = {}
    open(url) do |f|
      f.each_line.with_index do |line, index|
        line = line.strip
        if line.start_with?('<h1 class="price">')
          details[:price] = child_text(Document.new(line)).to_f
        elsif line.start_with?("<input") && line.include?("edit-submit")
          details[:available] = line.include?("Niet meer beschikbaar")
        end
      end
    end
    details
  end

  def self.child_text(node)
    XPath.match(node, ".//text()").join.strip
  end
end
