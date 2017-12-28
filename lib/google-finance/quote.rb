module GoogleFinance
  class Quote < Resource
    property 'symbol' # symbol name
    property 'reuters_url', from: 'f_reuters_url', with: ->(v) { URI(v) } # detailed information on reuters.com
    property 'exchange' # name of the exchange
    property 'id' # ?
    property 't' # ?
    property 'e' # ?
    property 'name' # company name
    property 'f_recent_quarter_date' # ?
    property 'f_annual_date' # ?
    property 'f_ttm_date' # financial trailing twelve months date?
    property 'financials' # ?
    property 'kr_recent_quarter_date' # ?
    property 'kr_annual_date' # ?
    property 'kr_ttm_date' # ?
    property 'keyratios' # ?
    property 'change', from: 'c', with: ->(v) { v.to_f if v } # change today
    property 'last_trade_price', from: 'l', with: ->(v) { v.to_f if v } # last trade price
    property 'change_in_percent', from: 'cp', with: ->(v) { v.to_f if v } # change in percent
    property 'ccol' # ? eg. chg
    property 'open', from: 'op', with: ->(v) { v.to_f if v } # open
    property 'high', from: 'hi', with: ->(v) { v.to_f if v } # high
    property 'low', from: 'lo', with: ->(v) { v.to_f if v } # low
    property 'volume', from: 'vo' # volume, eg. 25M, TODO: convert to integer
    property 'average_volume', from: 'avvo' # average volume
    property 'high_52_week', from: 'hi52', with: ->(v) { v.to_f if v } # 52 week high
    property 'low_52_week', from: 'lo52', with: ->(v) { v.to_f if v } # 52 week low
    property 'market_capitalization', from: 'mc' # market cap
    property 'price_earnings_ratio', from: 'pe', with: ->(v) { v.to_f if v } # price-earnings ratio
    property 'fwpe' # ?
    property 'beta' # ?
    property 'earnings_per_share', from: 'eps', with: ->(v) { v.to_f if v } # earnings per share
    property 'dy' # ?
    property 'ldiv' # ?
    property 'shares' # ?
    property 'instown' # ?
    property 'eo' # ?
    property 'sid' # ?
    property 'sname' # ?
    property 'iid' # ?
    property 'iname' # ?
    property 'related' # ?
    property 'summary' # ?
    property 'management' # ?
    property 'moreresources' # ?
    property 'events' # ?

    def change_in_percent_s
      [
        change_in_percent > 0 ? '+' : '',
        format('%.2f', change_in_percent),
        '%'
      ].join
    end

    def self.get(symbol)
      data = GoogleFinance::Api::Index.get(q: symbol)
      if data.is_a?(Hash) && data.key?('searchresults')
        if data['searchresults'].size >= 1
          get(data['searchresults'].first['symbol'])
        else
          raise GoogleFinance::Errors::SymbolNotFoundError.new(symbol, data)
        end
      elsif data.is_a?(Array) && data.size == 1
        new data.first
      else
        raise GoogleFinance::Errors::SymbolNotFoundError.new(symbol, data)
      end
    end
  end
end
