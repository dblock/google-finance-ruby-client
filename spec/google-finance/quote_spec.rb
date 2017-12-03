require 'spec_helper'

describe GoogleFinance::Quote do
  context 'known symbol', vcr: { cassette_name: 'msft' } do
    subject do
      GoogleFinance::Quote.get('MSFT')
    end
    it 'retrieves a quote' do
      expect(subject.symbol).to eq 'MSFT'
      expect(subject.exchange).to eq 'NASDAQ'
      expect(subject.id).to eq '358464'
      expect(subject.name).to eq 'Microsoft Corporation'
    end
    it 'renames and coerces reuters_url' do
      expect(subject.reuters_url).to eq URI('http://stocks.us.reuters.com/stocks/ratios.asp?rpc=66&symbol=MSFT.O')
    end
    it 'coerces numbers' do
      expect(subject.last).to eq 84.26
      expect(subject.change).to eq 0.09
      expect(subject.change_in_percent).to eq 0.11
    end
  end
  context 'invalid symbol', vcr: { cassette_name: 'invalid' } do
    subject do
      GoogleFinance::Quote.get('INVALID')
    end
    it 'fails with SymbolNotFoundError' do
      expect { subject }.to raise_error GoogleFinance::Errors::SymbolNotFoundError, 'Symbol INVALID Not Found'
    end
  end
end
