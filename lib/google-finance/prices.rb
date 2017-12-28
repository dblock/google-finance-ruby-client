module GoogleFinance
  class Prices < Array
    extend Forwardable

    def_delegators :@headers, :exchange, :market_open_minute, :market_close_minute, :interval, :columns, :timezone_offset

    def initialize(headers, values = [])
      @headers = OpenStruct.new(headers)
      super values
    end

    def self.get(symbol, params = {})
      data = GoogleFinance::Api::GetPrices.fetch({ q: symbol }.merge(params))
      headers = {}
      rows = []
      start_ts = Time.at(0)
      data.each_line do |line|
        line = CGI.unescape(line)
        if line =~ /(?<k>.+)\=(?<v>.*)/
          k = Regexp.last_match[:k].downcase.to_sym
          headers[k] = case k
                       when :columns then
                         Regexp.last_match[:v].split(',').map(&:downcase)
                       when :market_open_minute, :market_close_minute, :interval, :timezone_offset then
                         Regexp.last_match[:v].to_i
                       else
                         Regexp.last_match[:v]
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
          rows << GoogleFinance::Price.new(row)
        end
      end
      new headers, rows
    end
  end
end
