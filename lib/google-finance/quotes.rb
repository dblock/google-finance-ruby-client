module GoogleFinance
  class Quotes
    def self.search(*symbols)
      results = GoogleFinance::Api::Index.get(q: symbols.join(','))
      if results.is_a?(Hash) && results.key?('searchresults')
        searchresults = results['searchresults']
        raise GoogleFinance::Errors::SymbolsNotFoundError.new(symbols, results) if searchresults.empty?
        searchresults.map do |r|
          Quote.get r['ticker']
        end
      elsif results.is_a?(Array)
        results.map do |r|
          Quote.new(r)
        end
      else
        raise GoogleFinance::Errors::SymbolsNotFoundError.new(symbols, results)
      end
    end
  end
end
