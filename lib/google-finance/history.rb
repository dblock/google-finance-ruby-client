module GoogleFinance
  module History
    def self.get(symbol, params = {})
      query = {}
      params.each_pair do |k, v|
        case k
        when :startdate, :start_date then
          query[:startdate] = v.strftime('%-d-%b-%Y')
        when :enddate, :end_date then
          query[:enddate] = v.strftime('%-d-%b-%Y')
        else
          raise ArgumentError, "Invalid parameter: #{k}."
        end
      end
      data = CSV.parse(GoogleFinance::Api::Historical.fetch(
        { q: symbol }.merge(query)
      ).force_encoding('UTF-8'), headers: true, header_converters: :symbol)
      data.map do |row|
        Price.new(
          'date' => Date.parse(row[:date]),
          'open' => row[:open].to_f,
          'close' => row[:close].to_f,
          'high' => row[:high].to_f,
          'low' => row[:low].to_f,
          'volume' => row[:volume].to_i
        )
      end
    rescue Faraday::ClientError => e
      raise GoogleFinance::Errors::SymbolNotFoundError.new(symbol, e.response) if
        e.response[:status] == 400 &&
        e.response[:body].include?('The requested URL was not found on this server.')
      raise e
    end
  end
end
