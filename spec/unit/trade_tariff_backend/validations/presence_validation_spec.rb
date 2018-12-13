require 'rails_helper'

describe TradeTariffBackend::Validations::PresenceValidation do
  describe '#valid?' do
    let(:record) { double(a: 'a', b: 'b', c: nil).as_null_object }

    context 'all arguments are present on record' do
      let(:validation) {
        described_class.new(:vld1, 'valid', validation_options: { of: %i[a b] })
      }

      it 'returns true' do
        expect(
          validation
        ).to be_valid(record)
      end
    end

    context 'some arguments are present on record' do
      let(:validation) {
        described_class.new(:vld1, 'valid', validation_options: { of: %i[a b c] })
      }

      it 'returns false' do
        expect(
          validation
        ).not_to be_valid(record)
      end
    end
  end
end
