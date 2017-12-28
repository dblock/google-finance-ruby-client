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
      expect(subject.timezone_offset).to eq -300
      expect(subject.count).to eq 21
    end
    context 'row' do
      let(:price) { subject.first }
      it 'includes a price' do
        expect(price).to be_a GoogleFinance::Price
        expect(price.close).to eq 84.88
        expect(price.high).to eq 85.06
        expect(price.low).to eq 84.02
        expect(price.open).to eq 84.07
        expect(price.volume).to eq 21_925_959
        expect(price.date).to eq Time.parse('2017-11-28 16:00 -0500')
      end
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
