require 'rails_helper'

describe TradeTariffBackend::Validations::ExclusionValidation do
  describe '#valid?' do
    context 'argument is an Array' do
      let(:model) { double(attr: :c) }
      let(:validation) {
        described_class.new(:vld1, 'valid', validation_options: { of: :attr,
                                                                  from: %i[a b c] })
      }

      it 'validates' do
        expect(validation).not_to be_valid(model)
      end
    end

    context 'argument is a Proc' do
      let(:model) { double(attr: :c) }
      let(:validation) {
        described_class.new(:vld1, 'valid', validation_options: { of: :attr,
                                                                 from: -> { %i[a b c] } })
      }

      it 'validates' do
        expect(validation).not_to be_valid(model)
      end
    end

    context 'no valid argument to check for povided' do
      let(:record) { double }
      let(:validation) {
        described_class.new(:vld1, 'valid', validation_options: { in: :attr })
      }

      it 'raises ArgumentError' do
        expect { validation.valid?(record) }.to raise_error ArgumentError
      end
    end
  end
end
