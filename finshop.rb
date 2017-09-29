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

available_products = store.load.select(&:available?)
Notifier.new(available_products).notify(:prowl)
