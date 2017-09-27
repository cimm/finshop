#!/usr/bin/env ruby

require "./crawler"
require "./product"
require "./store"

keyword  = ARGV.first
results  = Crawler.search(keyword)
products = Product.from_results(results)
store    = Store.new
store.upsert(products)
