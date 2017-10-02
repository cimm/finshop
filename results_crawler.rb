require_relative "./crawler"

class ResultsCrawler < Crawler
  def initialize(keyword)
    @keyword = keyword
    @url     = url
    @data    = []
  end

  private

  def parse_line(line)
    if result_line?(line)
      @data << { title: title_from_line(line),
                 url: url_from_line(line) }
    end
  end

  def result_line?(line)
    line.start_with?('<div class="views-field views-field-title">')
  end

  def title_from_line(line)
    doc = Document.new(line)
    XPath.match(doc, ".//text()").join.strip
  end

  def url_from_line(line)
    doc = Document.new(line)
    link = doc.get_elements("//a").first
    BASE_URL + link.attributes["href"]
  end

  def url
    BASE_URL + "/nl/search?search_api_views_fulltext=" + @keyword
  end
end
