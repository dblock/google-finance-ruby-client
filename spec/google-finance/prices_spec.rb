require 'spec_helper'

describe GoogleFinance::Prices do
  context 'known symbol', vcr: { cassette_name: 'get_prices_msft' } do
    subject do
      GoogleFinance::Prices.get('MSFT')
    end
    it 'retrieves price history' do
      expect(subject.exchange).to eq 'NASDAQ'
      expect(subject.market_open_minute).to eq 570
      expect(subject.market_close_minute).to eq 960
      expect(subject.interval).to eq 86_400
      expect(subject.columns).to eq(%w[date close high low open volume])
      expect(subject.count).to eq 21
    end
    context 'row' do
      let(:price) { subject.first }
      it 'includes a price' do
        expect(price).to be_a GoogleFinance::Price
        expect(price.timezone_offset).to eq -300
        expect(price.close).to eq 84.88
        expect(price.high).to eq 85.06
        expect(price.low).to eq 84.02
        expect(price.open).to eq 84.07
        expect(price.volume).to eq 21_925_959
        expect(price.date).to eq Time.parse('2017-11-28 16:00 -0500')
      end
    end
  end
  context 'with custom fields', vcr: { cassette_name: 'get_prices_goog_with_options' } do
    subject do
      GoogleFinance::Prices.get('GOOG', i: 60 * 60, p: '1Y', f: 'd,c,v,k,o,h,l', df: 'cpct', auto: 0)
    end
    it 'retrieves price history' do
      expect(subject.exchange).to eq 'NASDAQ'
      expect(subject.interval).to eq 3600
      expect(subject.columns).to eq(%w[date close high low open volume cdays])
      expect(subject.count).to eq 1755
    end
    it 'knows timezone_offset' do
      expect(subject.first.timezone_offset).to eq -300
      expect(subject[1024].timezone_offset).to eq -240
      expect(subject.last.timezone_offset).to eq -300
    end
  end
  context 'with custom named fields', vcr: { cassette_name: 'get_prices_goog_with_options' } do
    subject do
      GoogleFinance::Prices.get('GOOG', interval: 60 * 60, period: '1Y', fields: %i[date close volume k open high low], df: 'cpct', auto: 0)
    end
    it 'retrieves price history' do
      expect(subject.exchange).to eq 'NASDAQ'
      expect(subject.interval).to eq 3600
      expect(subject.columns).to eq(%w[date close high low open volume cdays])
      expect(subject.count).to eq 1755
    end
    it 'knows timezone_offset' do
      expect(subject.first.timezone_offset).to eq -300
      expect(subject[1024].timezone_offset).to eq -240
      expect(subject.last.timezone_offset).to eq -300
    end
  end
  context 'intraday', vcr: { cassette_name: 'get_prices_goog_intraday' } do
    subject do
      GoogleFinance::Prices.get('GOOG', i: 60 * 60, p: '1d', f: 'd,c,v,k,o,h,l')
    end
    it 'retrieves intraday price history' do
      expect(subject.exchange).to eq 'NASDAQ'
      expect(subject.interval).to eq 3600
      expect(subject.columns).to eq(%w[date close high low open volume cdays])
      expect(subject.count).to eq 7
    end
  end
  context 'with few fields', vcr: { cassette_name: 'get_prices_goog_with_few_fields' } do
    subject do
      GoogleFinance::Prices.get('GOOG', fields: %i[date close])
    end
    it 'retrieves price history' do
      expect(subject.exchange).to eq 'NASDAQ'
      expect(subject.columns).to eq(%w[date close])
      expect(subject.count).to eq 21
    end
    it 'retrieves some fields' do
      price = subject.first
      expect(price.close).to eq 1047.41
      expect(price.date).to eq Time.parse('2017-11-28 16:00:00 -0500')
      expect(price.timezone_offset).to eq -300
      expect(price.high).to be nil
    end
  end
  context 'unknown symbol', vcr: { cassette_name: 'get_prices_invalid' } do
    subject do
      GoogleFinance::Prices.get('INVALID')
    end
    it 'fails with SymbolNotFoundError' do
      expect { subject }.to raise_error GoogleFinance::Errors::SymbolNotFoundError, 'Symbol INVALID Not Found'
    end
  end
end
