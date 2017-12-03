module GoogleFinance
  module Errors
    class SymbolsNotFoundError < StandardError
      attr_reader :symbols
      attr_reader :response

      def initialize(symbols, response)
        @response = response
        @symbols = symbols
        super "One or More Symbols #{symbols.join(' ')} Not Found"
      end
    end
  end
end
