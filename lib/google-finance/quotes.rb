module GoogleFinance
  class Quotes
    def self.get(*symbols)
      Resources.fetch(q: symbols.join(','))['searchresults'].map do |r|
        Quote.get r['ticker']
      end
    end
  end
end
