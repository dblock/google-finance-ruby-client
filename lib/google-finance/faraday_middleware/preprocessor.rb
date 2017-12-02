module GoogleFinance
  module FaradayMiddleware
    class Preprocessor < ::FaradayMiddleware::ResponseMiddleware
      define_parser do |body, _|
        # JSON starts with \n//, eg. https://finance.google.com/finance/q=MSFT&output=json
        body.gsub /^\n\/\//, ''
      end
    end
  end
end
