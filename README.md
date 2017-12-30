Google Finance Ruby Client
==========================

[![Gem Version](https://badge.fury.io/rb/google-finance-ruby-client.svg)](https://badge.fury.io/rb/google-finance-ruby-client)
[![Build Status](https://travis-ci.org/dblock/google-finance-ruby-client.svg?branch=master)](https://travis-ci.org/dblock/google-finance-ruby-client)

A Ruby client for the undocumented Google Finance web API. Supports stock quotes and historical prices. Attempts to make sense of, coerce and structure the data.

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

Fetches stock quotes via [https://finance.google.com/finance](lib/google-finance/api/index.rb).

```ruby
quote = GoogleFinance::Quote.get('MSFT')

quote.last_trade_price # 84.26
quote.change # 0.09
quote.change_in_percent # 0.11
quote.change_in_percent_s # "+0.11%"
```

See [quote.rb](lib/google-finance/quote.rb) for returned fields.

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

#### Daily Price History

Fetches price history for a ticker via [https://finance.google.com/finance/historical](lib/google-finance/api/historical.rb).

```ruby
prices = GoogleFinance::History.get('MSFT')

# prices for the last year of open markets
prices.count # 251

# prices appear in reverse chronological order
prices.first #<GoogleFinance::Price close=85.54 date=#<Date: 2017-12-29> high=86.05 low=85.5 open=85.63 volume=18717406>
prices[1] #<GoogleFinance::Price close=85.72 date=#<Date: 2017-12-28> high=85.93 low=85.55 open=85.9 volume=10594344>
 ```

If a symbol cannot be found a [GoogleFinance::Errors::SymbolNotFound](lib/google-finance/errors/symbol_not_found_error.rb) is raised.

The following options are supported.

* `start_date`: date to start from
* `end_date`: date to retrieve to

Retrieve prices in the first days of 2016. No trading on the week-end.

```ruby
prices = GoogleFinance::History.get('MSFT', start_date: Date.parse('2016-01-03'), end_date: Date.parse('2016-01-10'))

prices.count # 5
prices.first # #<GoogleFinance::Price close=52.33 date=#<Date: 2016-01-08> high=53.28 low=52.15 open=52.37 volume=48753969>
```

#### Intraday Price History

Fetches price history, including at intraday intervals, for a ticker via [https://finance.google.com/finance/getprices](lib/google-finance/api/get_prices.rb).

```ruby
prices = GoogleFinance::Prices.get('MSFT')

prices.exchange # NASDAQ

# prices for the last month of open markets
prices.count # 21

# prices appear in reverse chronological order
prices.last #<GoogleFinance::Price close=85.71 date=2017-12-27 16:00:00 -0500 high=85.98 low=85.215 open=85.65 volume=14678025>
prices[-2] #<GoogleFinance::Price close=85.4 date=2017-12-26 16:00:00 -0500 high=85.5346 low=85.03 open=85.31 volume=9891237>
```

See [price.rb](lib/google-finance/price.rb) for returned fields.

If a symbol cannot be found a [GoogleFinance::Errors::SymbolNotFound](lib/google-finance/errors/symbol_not_found_error.rb) is raised.

The following options are supported.

* `exchange`: stock exchange symbol on which stock is traded, eg. `NASDAQ`
* `interval`: interval size in seconds
* `period`: period, a number followed by `d` (days) or `Y` (years)
* `fields`: array of data to return
  * `date`: timestamp
  * `open`: price at market open
  * `close`: price at market close
  * `volume`: volume
  * `low`: low price
  * `high`: high price

Retrieve intraday prices in 1 hour intervals.

```ruby
prices = GoogleFinance::Prices.get('GOOG', interval: 60 * 60, period: '1d')

prices.count # 7

prices # array of GoogleFinance::Price, date=2017-12-29 10:00AM, 11:00AM, etc.
```

Retrieve only prices at market close.

```ruby
prices = GoogleFinance::Prices.get('GOOG', fields: [:days, :close])

prices.first # #<GoogleFinance::Price close=1047.41 date=2017-11-28 16:00:00 -0500>
```

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright and License

Copyright (c) 2017, [Daniel Doubrovkine](https://twitter.com/dblockdotorg) and [Contributors](CHANGELOG.md).

This project is licensed under the [MIT License](LICENSE.md).
