require "net/https"


class Notifier
  PROWL_APPLICATION = "FinShop"
  PROWL_URL         = URI("https://api.prowlapp.com/publicapi/add")
  PROWL_KEY         = ENV["PROWL_KEY"]

  def initialize(products)
    @products = products
  end

  def notify(channel = :stdout)
    return if @products.empty?

    case channel
      when :prowl then notify_prowl
      else notify_stdout
    end
  end

  def notify_prowl
    raise MissingKeyError unless PROWL_KEY
    Net::HTTP.post_form(PROWL_URL,
                        apikey: PROWL_KEY,
                        application: PROWL_APPLICATION,
                        description: message)
  rescue MissingKeyError
    puts "Missing PROWL_KEY, falling back to stdout."
    notify_stdout
  end

  def notify_stdout
    puts message
  end

  def message
    message = "New products found:\n"
    @products.inject(message) do |memo, product|
      memo += "#{product.title} (€#{product.price})\n"
    end
  end
end

class MissingKeyError < StandardError; end
