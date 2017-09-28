require "net/https"

class Notifier
  PROWL_APPLICATION = "FinShop"
  PROWL_URL         = URI("https://api.prowlapp.com/publicapi/add")
  PROWL_KEY         = ENV.fetch("PROWL_KEY")

  def self.notify(message)
    Net::HTTP.post_form(PROWL_URL,
                        apikey: PROWL_KEY,
                        application: PROWL_APPLICATION,
                        description: message)
  end
end
