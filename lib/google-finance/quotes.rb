module GoogleFinance
  class Quotes
    def self.search(*symbols)
      results = Resources.fetch(q: symbols.join(','))
      searchresults = results['searchresults']
      raise GoogleFinance::Errors::SymbolsNotFoundError.new(symbols, results) if searchresults.empty?
      searchresults.map do |r|
        Quote.get r['ticker']
      end
    end
  end
end
