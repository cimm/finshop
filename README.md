# FinShop Notifier

A little Ruby script that searches the [FinShop](https://finshop.belgium.be) webshop for a given keyword and prints a message to `stdout` or sends a push notification to your phone (via [Prowl](https://www.prowlapp.com)) if new products are found. The script is smart enough to remember the products it notfied you for so you'll only see new products once.

## Usage

Make sure you have a somewhat recent version of Ruby installed (was tested in `2.3.5` but should run with slightly older versions as well). Download or clone this repository and run the script.

Search for all products with `keyword` and print the results to `stdout`:

```bash
$ ruby finshop.rb keyword
```

Search for all products with `keyword` and send a push notification via Prowl:

```bash
$ PROWL_KEY=abc123 ruby finshop.rb keyword
```

## Why

As a small exercise to see what's possible using only Ruby's [Standard Lirbrary](https://ruby-doc.org/stdlib), without using any gems. Seems it's not that hard to create a fully funcational little application thingy without any dependencies. I discovered the [YAML::Store](https://ruby-doc.org/stdlib/libdoc/yaml/rdoc/YAML/Store.html) library, which can easily be used to persist simple data structures, but was dissapointed by the lack of HTML parser in the Standard Library. You'll find [REXML](https://ruby-doc.org/stdlib/libdoc/rexml/rdoc/REXML.html) but HTML is not (always) XML so I had to revert to string matching.
