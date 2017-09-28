require "./crawler"

class DetailCrawler < Crawler
  def initialize(url)
    @url  = url
    @data = {}
  end

  private

  def parse_line(line)
    if price_line?(line)
      @data[:price] = price_from_line(line)
    elsif availability_line?(line)
      @data[:available] = availability_from_line(line)
    end
  end

  def price_line?(line)
    line.start_with?('<h1 class="price">')
  end

  def price_from_line(line)
    doc  = Document.new(line)
    text = XPath.match(doc, ".//text()").join
    text.to_f
  end

  def availability_line?(line)
    line.include?("edit-submit")
  end

  def availability_from_line(line)
    return false if line.include?("Niet meer beschikbaar")
    return true if line.include?("Aan winkelmandje toevoegen")
  end
end
