module GoogleFinance
  module Api
    module Historical
      def self.fetch(params)
        connection.get do |c|
          c.params[:output] = :csv
          c.params.merge!(params)
        end.body
      end

      def self.connection
        Faraday.new(
          url: 'https://finance.google.com/finance/historical',
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
