require 'rails_helper'

describe MeasureType do
  describe 'validations' do
    # MT1 The measure type code must be unique.
    it { should validate_uniqueness.of :measure_type_id }
    # MT2 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }
    # MT4 The referenced measure type series must exist.
    it { should validate_presence.of(:measure_type_series) }

    describe "MT3" do
      let(:measure_type) do
        create :measure_type,
               validity_start_date: Date.today,
               validity_end_date: (Date.today + 10.days)
      end
      let(:measure) do
        create :measure,
               validity_start_date: Date.today,
               validity_end_date: (Date.today + 10.days),
               measure_type_id: measure_type.measure_type_id
      end

      it "shouldn't allow to use a measure type that doesn't span the validity period of a measure" do
        measure
        measure_type.reload
        measure_type.validity_end_date = Date.tomorrow
        expect(measure_type.conformant?).to eq(false)
        expect(measure_type.conformance_errors).to have_key(:MT3)
      end
    end

    describe "MT7" do
      let(:measure_type) { create :measure_type }
      let(:measure) { create :measure, measure_type_id: measure_type.measure_type_id }

      it "shouldn't allow a measure type to be deleted if it's used by a measure" do
        measure
        expect(
          measure_type.reload.conformant_for?(:destroy)
        ).to be_falsey
        expect(measure_type.conformance_errors).to have_key(:MT7)
      end
    end

    describe "MT10" do
      let(:measure_type) do
        create :measure_type,
               validity_end_date: Date.today + 10.days
      end
      let(:measure_type_series) do
        create :measure_type_series,
               measure_type_series_id: measure_type.measure_type_series_id,
               validity_end_date: Date.today + 11.days
      end

      it "measure type series spans validity period of measure" do
        measure_type.measure_type_series.validity_end_date = Date.today + 3.days
        expect(measure_type.conformant?).to be_falsey
        expect(measure_type.conformance_errors).to have_key(:MT10)
      end
    end
  end

  describe '#excise?' do
    let(:measure_type) { build :measure_type, measure_type_id: measure_type_description.measure_type_id, measure_type_description: measure_type_description }

    context 'measure type is Excise related' do
      let!(:measure_type_description) { create :measure_type_description, description: 'EXCISE 111' }

      it 'returns true' do
        expect(measure_type).to be_excise
      end
    end

    context 'measure type is not Excise related' do
      let(:measure_type_description) { create :measure_type_description, description: 'not really e_x_c_i_s_e' }

      it 'returns false' do
        expect(measure_type).not_to be_excise
      end
    end
  end

  describe '#third_country?' do
    context 'measure_type is third country' do
      let(:measure_type) { build :measure_type, measure_type_id: MeasureType::THIRD_COUNTRY }

      it 'returns true' do
        expect(measure_type).to be_third_country
      end
    end

    context 'measure_type is not third country' do
      let(:measure_type) { build :measure_type, measure_type_id: 'aaa' }

      it 'returns false' do
        expect(measure_type).not_to be_third_country
      end
    end
  end
end
