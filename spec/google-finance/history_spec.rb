require 'spec_helper'

describe GoogleFinance::History do
  context 'known symbol', vcr: { cassette_name: 'historical_msft' } do
    subject do
      GoogleFinance::History.get('MSFT')
    end
    it 'retrieves price history' do
      expect(subject.count).to eq 251
    end
    context 'row' do
      let(:price) { subject.first }
      it 'includes details' do
        expect(price).to be_a GoogleFinance::Price
        expect(price.close).to eq 85.54
        expect(price.high).to eq 86.05
        expect(price.low).to eq 85.5
        expect(price.open).to eq 85.63
        expect(price.volume).to eq 18_717_406
        expect(price.date).to eq Date.parse('2017-12-29')
      end
    end
  end
  context 'with custom start and end fields', vcr: { cassette_name: 'historical_msft_with_date_options' } do
    subject do
      GoogleFinance::History.get('MSFT', start_date: Date.parse('2016-01-03'), end_date: Date.parse('2016-01-10'))
    end
    it 'retrieves price history' do
      expect(subject.count).to eq 5
    end
    it 'matches dates' do
      expect(subject.last.date).to eq Date.parse('2016-01-04')
      expect(subject.first.date).to eq Date.parse('2016-01-08')
    end
  end
  context 'on a weekend', vcr: { cassette_name: 'historical_msft_weekend' } do
    subject do
      GoogleFinance::History.get('MSFT', start_date: Date.parse('2016-01-01'), end_date: Date.parse('2016-01-02'))
    end
    it 'retrieves en empty set' do
      expect(subject.count).to eq 0
    end
  end
  context 'unknown symbol', vcr: { cassette_name: 'historical_invalid' } do
    subject do
      GoogleFinance::History.get('INVALID')
    end
    it 'fails with SymbolNotFoundError' do
      expect { subject }.to raise_error GoogleFinance::Errors::SymbolNotFoundError, 'Symbol INVALID Not Found'
    end
  end
end
