class Product
  attr_writer :available, :new
  attr_reader :updated_at
  attr_accessor :title, :url, :price

  def initialize(title:, price:, url:, available:)
    @title      = title
    @price      = price
    @url        = url
    @available  = available
    @new        = true
    @updated_at = Time.now.round
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

  def new?
    @new
  end

  def formatted_price
    "€%.2f" % price
  end

  def equal?(product)
    return false if product.url.empty?
    url.downcase == product.url.downcase
  end

  def update(product)
    self.title     = product.title
    self.price     = product.price
    self.available = product.available?
    self.new       = false
    self
  end
end
