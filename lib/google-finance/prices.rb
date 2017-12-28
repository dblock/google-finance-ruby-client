module GoogleFinance
  class Prices < Array
    extend Forwardable

    def_delegators :@headers, :exchange, :market_open_minute, :market_close_minute, :interval, :columns, :timezone_offset

    def initialize(headers, values = [])
      @headers = OpenStruct.new(headers)
      super values
    end

    def self.get(symbol, params = {})
      query = {}
      params.each_pair do |k, v|
        case k
        when :exchange, :x then
          query[:x] = v
        when :interval, :i then
          query[:i] = v
        when :period, :p then
          query[:p] = v
        when :df then
          query[:df] = v
        when :auto then
          query[:auto] = v
        when :ei then
          query[:ei] = v
        when :fields, :f then
          query[:f] = (v.is_a?(String) ? v.split(',').map(&:to_sym) : v).map do |f|
            case f
            when :date, :d then :d
            when :open, :o then :o
            when :close, :c then :c
            when :volume, :v then :v
            when :low, :l then :l
            when :high, :h then :h
            when :k then :k
            else
              raise ArgumentError, "Invalid fields: #{v}."
            end
          end.join(',')
        else
          raise ArgumentError, "Invalid parameter: #{k}."
        end
      end
      data = GoogleFinance::Api::GetPrices.fetch({ q: symbol }.merge(query))
      headers = {}
      rows = []
      start_ts = Time.at(0)
      timezone_offset = 0
      data.each_line do |line|
        line = CGI.unescape(line)
        if line =~ /(?<k>.+)\=(?<v>.*)/
          k = Regexp.last_match[:k].downcase.to_sym
          case k
          when :columns then
            headers[k] = Regexp.last_match[:v].split(',').map(&:downcase)
          when :market_open_minute, :market_close_minute, :interval then
            headers[k] = Regexp.last_match[:v].to_i
          when :timezone_offset then
            timezone_offset = Regexp.last_match[:v].to_i
          else
            headers[k] = Regexp.last_match[:v]
          end
        else
          values = line.split(',')
          raise "Unexpected number of columns, #{values.count} vs. #{headers[:columns].size}." if (headers[:columns] || []).size != values.count
          row = {}
          if headers[:columns]
            headers[:columns].each_with_index do |name, ndx|
              row[name] = case name
                          when 'date' then
                            if values[ndx] =~ /^a(?<ts>.*)/
                              # https://stackoverflow.com/questions/45897894/convert-timestamps-in-google-finance-stock-data-to-proper-datetime
                              #
                              # The full timestamps are denoted by the leading 'a'. Like this: a1092945600. The number after the 'a' is a Unix timestamp.
                              # The numbers without a leading 'a' are "intervals".
                              #
                              start_ts = Time.at(Regexp.last_match[:ts].to_i)
                            else
                              start_ts + (headers[:interval] || 1) * values[ndx].to_i
                            end
                          when 'volume' then
                            values[ndx].to_i
                          else
                            values[ndx].to_f
              end
            end
          end
          rows << GoogleFinance::Price.new({ 'timezone_offset' => timezone_offset }.merge(row))
        end
      end
      raise GoogleFinance::Errors::SymbolNotFoundError.new(symbol, data) if rows.count == 0 && headers[:exchange] == 'UNKNOWN EXCHANGE'
      new headers, rows
    end
  end
end
