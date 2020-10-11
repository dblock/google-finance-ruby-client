module GoogleFinance
  module Api
    module Index
      def self.get(params)
        connection.get do |c|
          c.params[:output] = :json
          c.params.merge!(params)
        end.body
      end

      def self.connection
        Faraday.new(
          url: 'https://www.google.com/finance',
          request: {
            params_encoder: Faraday::FlatParamsEncoder
          }
        ) do |c|
          c.adapter ::FaradayMiddleware::ParseJson
          c.adapter GoogleFinance::FaradayMiddleware::Preprocessor
          c.adapter Faraday::Response::RaiseError
          c.adapter Faraday::Adapter::NetHttp
        end
      end
    end
  end
end
