module GoogleFinance
  class Quote < Resource
    property 'symbol' # symbol name
    property 'reuters_url', from: 'f_reuters_url', with: ->(v) { URI(v) } # detailed information on reuters.com
    property 'exchange' # name of the exchange
    property 'id'
    property 't'
    property 'e'
    property 'name'
    property 'f_recent_quarter_date'
    property 'f_annual_date'
    property 'f_ttm_date'
    property 'financials'
    property 'kr_recent_quarter_date'
    property 'kr_annual_date'
    property 'kr_ttm_date'
    property 'keyratios'
    property 'change', from: 'c', with: ->(v) { v.to_f } # change today
    property 'last_trade_price', from: 'l', with: ->(v) { v.to_f } # last trade price
    property 'change_in_percent', from: 'cp', with: ->(v) { v.to_f } # change in percent
    property 'ccol'
    property 'op'
    property 'hi'
    property 'lo'
    property 'vo'
    property 'avvo'
    property 'hi52'
    property 'lo52'
    property 'mc'
    property 'pe'
    property 'fwpe'
    property 'beta'
    property 'eps'
    property 'dy'
    property 'ldiv'
    property 'shares'
    property 'instown'
    property 'eo'
    property 'sid'
    property 'sname'
    property 'iid'
    property 'iname'
    property 'related'
    property 'summary'
    property 'management'
    property 'moreresources'
    property 'events'

    def change_in_percent_s
      [
        change_in_percent > 0 ? '+' : '',
        format('%.2f', change_in_percent),
        '%'
      ].join
    end

    def self.get(symbol)
      data = Resources.fetch(q: symbol)
      if data.is_a?(Hash) && data.key?('searchresults')
        if data['searchresults'].size >= 1
          get(data['searchresults'].first['symbol'])
        else
          raise GoogleFinance::Errors::SymbolNotFoundError.new(symbol, data)
        end
      elsif data.is_a?(Array) && data.size == 1
        new data.first
      end
    end
  end
end
