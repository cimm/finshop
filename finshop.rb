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

new_products = store.load.select do |product|
  product.available? && product.new?
end

Notifier.new(new_products).notify(:prowl)
