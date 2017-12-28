module GoogleFinance
  class Price < Resource
    property 'timezone_offset'
    property 'date'
    property 'close'
    property 'symbol'
    property 'high'
    property 'low'
    property 'open'
    property 'volume'
    property 'cdays'
  end
end
