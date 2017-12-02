module GoogleFinance
  module Resources
    def self.fetch(params = {})
      get(params)
    end

    def self.get(params)
      connection.get do |c|
        c.params[:output] = :json
        c.params.merge!(params)
      end.body
    end

    def self.connection
      Faraday.new(
        url: 'https://finance.google.com/finance',
        request: {
          params_encoder: Faraday::FlatParamsEncoder
        }
      ) do |c|
        c.use ::FaradayMiddleware::ParseJson
        c.use GoogleFinance::FaradayMiddleware::Preprocessor
        c.use Faraday::Response::RaiseError
        c.use Faraday::Adapter::NetHttp
      end
    end
  end
end
