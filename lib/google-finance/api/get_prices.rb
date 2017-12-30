module GoogleFinance
  module Api
    module GetPrices
      #
      # Retrieve prices.
      #
      # http://www.networkerror.org/component/content/article/1-technical-wootness/44-googles-undocumented-finance-api.html
      # https://gist.github.com/lebedov/f09030b865c4cb142af1
      #
      # q: stock symbol
      # x: stock exchange symbol on which stock is traded, eg. NASD
      # i: interval size in seconds
      # p: period, a number followed by d (days) or Y (years)
      # f: data to return
      #  d: timestamp or interval
      #  c: close
      #  v: volume
      #  l: low
      #  o: open
      # df: difference
      #  cpct: change in percent
      # auto:
      #  1 : ?
      # ei: ?
      # ts: starting timetamp in unix format, default to today
      #
      # The output includes a header that describes the columns, timezone offset, and a few other interesting bits of information.
      # The data rows are basically CSV format.
      def self.fetch(params)
        connection.get do |c|
          c.params.merge!(params)
        end.body
      end

      def self.connection
        Faraday.new(
          url: 'https://finance.google.com/finance/getprices',
          request: {
            params_encoder: Faraday::FlatParamsEncoder
          }
        ) do |c|
          c.use Faraday::Response::RaiseError
          c.use Faraday::Adapter::NetHttp
        end
      end
    end
  end
end
