Google Finance Ruby Client
==========================

[![Gem Version](https://badge.fury.io/rb/google-finance-ruby-client.svg)](http://badge.fury.io/rb/google-finance-ruby-client)
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

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright and License

Copyright (c) 2017, [Daniel Doubrovkine](https://twitter.com/dblockdotorg) and [Contributors](CHANGELOG.md).

This project is licensed under the [MIT License](LICENSE.md).
