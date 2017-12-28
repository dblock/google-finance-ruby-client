module GoogleFinance
  class Price < Resource
    property 'date'
    property 'close'
    property 'symbol'
    property 'high'
    property 'low'
    property 'open'
    property 'volume'
  end
end
