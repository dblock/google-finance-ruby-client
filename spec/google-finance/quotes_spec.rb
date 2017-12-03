require 'spec_helper'

describe GoogleFinance::Quotes do
  context 'known symbol', vcr: { cassette_name: 'search_msft' } do
    subject do
      GoogleFinance::Quotes.search('MSFT')
    end
    it 'retrieves a single quote' do
      expect(subject.size).to eq 1
      expect(subject[0].symbol).to eq 'MSFT'
    end
  end
  context 'known symbols', vcr: { cassette_name: 'msft_ab' } do
    subject do
      GoogleFinance::Quotes.search('MSFT', 'AB')
    end
    it 'retrieves multiple quotes' do
      expect(subject.size).to eq 2
      expect(subject[0].symbol).to eq 'MSFT'
      expect(subject[1].symbol).to eq 'AB'
    end
  end
  context 'invalid symbol', vcr: { cassette_name: 'search_invalid' } do
    subject do
      GoogleFinance::Quotes.search('INVALID')
    end
    it 'retrieves a single quote' do
      expect { subject }.to raise_error GoogleFinance::Errors::SymbolsNotFoundError, 'One or More Symbols INVALID Not Found'
    end
  end
  context 'with an invalid symbol', vcr: { cassette_name: 'msft_ab_invalid' } do
    subject do
      GoogleFinance::Quotes.search('MSFT', 'AB', 'INVALID')
    end
    it 'retrieves multiple quotes' do
      expect { subject }.to raise_error GoogleFinance::Errors::SymbolsNotFoundError, 'One or More Symbols MSFT AB INVALID Not Found'
    end
  end
end
