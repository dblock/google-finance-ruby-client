Google Finance Ruby Client
==========================

[![Gem Version](https://badge.fury.io/rb/google-finance-ruby-client.svg)](https://badge.fury.io/rb/google-finance-ruby-client)
[![Build Status](https://travis-ci.org/dblock/google-finance-ruby-client.svg?branch=master)](https://travis-ci.org/dblock/google-finance-ruby-client)

A Ruby client for the undocumented Google Finance web API that attempts to make sense of the data.

<a href='http://finance.google.com/finance'>![](google-finance.png)</a>

_IANAL, but do note that if your application is for public consumption, using the Google Finance API [seems to be against Google's terms of service](https://groups.google.com/forum/#!msg/google-finance-apis/O8fjsgnamHE/-ZKSjif4yDIJ)._

## Installation

Add to Gemfile.

```
gem 'google-finance-ruby-client'
```

Run `bundle install`.

## Usage

### Get a Quote

```ruby
quote = GoogleFinance::Quote.get('MSFT')

quote.last_trade_price # 84.26
quote.change # 0.09
quote.change_in_percent # 0.11
quote.change_in_percent_s # "+0.11%"
```

See [quote.rb](lib/google_finance/quote.rb) for more fields.

If a symbol cannot be found a [GoogleFinance::Errors::SymbolNotFound](lib/google-finance/errors/symbol_not_found_error.rb) is raised.

### Get Multiple Quotes

Searches for a ticker or tickers, then fetches each quote.

```ruby
quotes = GoogleFinance::Quotes.search('MSFT', 'AB')

quotes.size # 2

quotes[0] # GoogleFinance::Quote.get('MSFT')
quotes[1] # GoogleFinance::Quote.get('AB')
```

If one of the symbols cannot be found a [GoogleFinance::Errors::SymbolsNotFound](lib/google-finance/errors/symbols_not_found_error.rb) is raised.

### Get Price History

Fetches price history for a ticker.

```ruby
prices = GoogleFinance::Prices.get('MSFT')

prices.exchange # NASDAQ

# prices for the last month of open markets
prices.count # 21

# prices appear in reverse chronological order
prices.last #<GoogleFinance::Price close=85.71 date=2017-12-27 16:00:00 -0500 high=85.98 low=85.215 open=85.65 volume=14678025>
prices[-2] #<GoogleFinance::Price close=85.4 date=2017-12-26 16:00:00 -0500 high=85.5346 low=85.03 open=85.31 volume=9891237>
```

The following options are supported.

* `x`: stock exchange symbol on which stock is traded, eg. `NASDAQ`
* `i`: interval size in seconds
* `p`: period, a number followed by `d` (days) or `Y` (years)
* `f`: comma-separated array of data to return
  * `d`: timestamp or interval
  * `o`: price at market open
  * `c`: price at market close
  * `v`: volume
  * `l`: low price
  * `h`: high price
  * `k`: ?
* `df`: ?, eg. `cpct`
* `auto`: ?
* `ei`: ?
* `ts`: starting timetamp in unix format, default to today

The following example retrieves prices for a year in 1 hour intervals.

```ruby
prices = GoogleFinance::Prices.get('GOOG', i: 60 * 60, p: '1Y', f: 'd,c,v,k,o,h,l')

prices.count # 1755
```

The following example retrieves prices at market close.

```ruby
prices = GoogleFinance::Prices.get('GOOG', f: 'd,c')

prices.first # #<GoogleFinance::Price close=1047.41 date=2017-11-28 16:00:00 -0500>
```

See [price.rb](lib/google_finance/price.rb) for available fields.

If a symbol cannot be found a [GoogleFinance::Errors::SymbolNotFound](lib/google-finance/errors/symbol_not_found_error.rb) is raised.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright and License

Copyright (c) 2017, [Daniel Doubrovkine](https://twitter.com/dblockdotorg) and [Contributors](CHANGELOG.md).

This project is licensed under the [MIT License](LICENSE.md).
