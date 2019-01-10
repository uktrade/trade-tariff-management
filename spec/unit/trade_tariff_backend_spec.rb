require 'rails_helper'

describe TradeTariffBackend do
  describe '.platform' do
    context 'platform should be Rails.env' do
      it 'defaults to Rails.env' do
        expect(described_class.platform).to eq Rails.env
      end
    end
  end
end
