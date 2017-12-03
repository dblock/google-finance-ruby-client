require 'spec_helper'

describe GoogleFinance::Quotes do
  context 'known symbols', vcr: { cassette_name: 'msft_ab' } do
    subject do
      GoogleFinance::Quotes.get('MSFT', 'AB')
    end
    it 'retrieves multiple quotes' do
      expect(subject.size).to eq 2
      expect(subject[0].symbol).to eq 'MSFT'
      expect(subject[1].symbol).to eq 'AB'
    end
  end
end
