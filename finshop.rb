#!/usr/bin/env ruby

require "./crawler"
require "./product"
require "./store"
require "./notifier"

keyword = ARGV.first

results  = Crawler.search(keyword)
products = Product.from_results(results)
store    = Store.new
store.upsert(products)

ten_minutes_ago = Time.now - 600
if store.since(ten_minutes_ago).any?
  Notifier.notify("New products available!")
end
