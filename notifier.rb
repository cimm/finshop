require "net/https"


class Notifier
  PROWL_APPLICATION = "FinShop"
  PROWL_URL         = URI("https://api.prowlapp.com/publicapi/add")
  PROWL_KEY         = ENV["PROWL_KEY"]

  def initialize(records)
    @records = records
  end

  def notify(channel = :stdout)
    return if @records.empty?

    message = "New products found:\n"
    message += @records.map(&:title).join("\n")

    case channel
      when :prowl then notify_prowl(message)
      else notify_stdout(message)
    end
  end

  def notify_prowl(message)
    raise MissingKeyError unless PROWL_KEY
    Net::HTTP.post_form(PROWL_URL,
                        apikey: PROWL_KEY,
                        application: PROWL_APPLICATION,
                        description: message)
  rescue MissingKeyError
    puts "Missing PROWL_KEY, falling back to stdout."
    notify_stdout(message)
  end

  def notify_stdout(message)
    puts message
  end
end

class MissingKeyError < StandardError; end
