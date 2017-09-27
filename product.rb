class Product
  attr_writer :available
  attr_reader :updated_at
  attr_accessor :title, :url, :price

  def initialize(title:, price:, url:, available:)
    @title      = title
    @price      = price
    @url        = url
    @available  = available
    @updated_at = Time.now
  end

  def self.from_results(results)
    results.inject([]) do |memo, result|
      memo << Product.new(title: result[:title],
                          url: result[:url],
                          price: result[:price],
                          available: result[:available])
    end
  end

  def available?
    @available
  end

  def formatted_price
    "€%.2f" % price
  end

  def equal?(product)
    return false if product.url.empty?
    url.downcase == product.url.downcase
  end
end
