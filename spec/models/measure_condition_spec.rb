require 'rails_helper'

describe MeasureCondition do
  describe 'associations' do
    describe 'monetary unit' do
      it_is_associated 'one to one to', :monetary_unit do
        let!(:left_primary_key) { :condition_monetary_unit_code }
        let!(:monetary_unit_code) { Forgery(:basic).text(exactly: 3) }
        let!(:condition_monetary_unit_code) { monetary_unit_code }
      end
    end

    describe 'measurement unit' do
      it_is_associated 'one to one to', :measurement_unit do
        let!(:left_primary_key) { :condition_measurement_unit_code }
        let!(:measurement_unit_code) { Forgery(:basic).text(exactly: 3) }
        let!(:condition_measurement_unit_code) { measurement_unit_code }
      end
    end

    describe 'measurement unit qualifier' do
      it_is_associated 'one to one to', :measurement_unit_qualifier do
        let!(:left_primary_key) { :condition_measurement_unit_qualifier_code }
        let!(:measurement_unit_qualifier_code) { Forgery(:basic).text(exactly: 1) }
        let!(:condition_measurement_unit_qualifier_code) { measurement_unit_qualifier_code }
      end
    end

    describe 'measure condition code' do
      it_is_associated 'one to one to', :measure_condition_code do
        let!(:condition_code) { Forgery(:basic).text(exactly: 1) }
      end
    end

    describe 'measure action' do
      it_is_associated 'one to one to', :measure_action do
        let!(:action_code) { Forgery(:basic).text(exactly: 1) }
      end
    end

    describe 'certificate type' do
      it_is_associated 'one to one to', :certificate_type do
        let!(:certificate_type_code) { Forgery(:basic).text(exactly: 1) }
      end
    end

    describe 'certificate' do
      it_is_associated 'one to one to', :certificate do
        let!(:certificate_code) { Forgery(:basic).text(exactly: 3) }
        let!(:certificate_type_code) { Forgery(:basic).text(exactly: 1) }
      end
    end

    describe 'measure condition components' do
      let!(:measure_condition)                { create :measure_condition }
      let!(:measure_condition_component1)     { create :measure_condition_component, measure_condition_sid: measure_condition.measure_condition_sid }
      let!(:measure_condition_component2)     { create :measure_condition_component, measure_condition_sid: generate(:measure_condition_sid) }

      context 'direct loading' do
        it 'loads associated measure condition components' do
          expect(
            measure_condition.measure_condition_components
          ).to include measure_condition_component1
        end

        it 'does not load associated measure component' do
          expect(
            measure_condition.measure_condition_components
          ).not_to include measure_condition_component2
        end
      end

      context 'eager loading' do
        it 'loads associated measure components' do
          expect(
            described_class.where(measure_condition_sid: measure_condition.measure_condition_sid)
                 .eager(:measure_condition_components)
                 .all
                 .first
                 .measure_condition_components
          ).to include measure_condition_component1
        end

        it 'does not load associated measure component' do
          expect(
            described_class.where(measure_condition_sid: measure_condition.measure_condition_sid)
                 .eager(:measure_condition_components)
                 .all
                 .first
                 .measure_condition_components
          ).not_to include measure_condition_component2
        end
      end
    end
  end

  describe '#requirement' do
    context 'with document requirement' do
      let(:certificate_type) {
        create :certificate_type, :with_description,
          description: 'FOO'
      }
      let(:certificate_description) {
        create :certificate_description, :with_period,
          certificate_type_code: certificate_type.certificate_type_code,
          description: 'BAR'
      }
      let(:certificate) {
        create :certificate,
          certificate_code: certificate_description.certificate_code,
          certificate_type_code: certificate_description.certificate_type_code
      }
      let(:measure_condition) {
        create :measure_condition,
          condition_code: 'L',
          component_sequence_number: 3,
          condition_duty_amount: nil,
          condition_monetary_unit_code: nil,
          condition_measurement_unit_code: nil,
          condition_measurement_unit_qualifier_code: nil,
          certificate_code: certificate.certificate_code,
          certificate_type_code: certificate.certificate_type_code
      }

      it 'returns requirement certificate type and description' do
        expect(measure_condition.requirement).to eq "FOO: BAR"
      end
    end

    context 'with duty expression requirement' do
      let(:monetary_unit) {
        create :monetary_unit, :with_description,
          monetary_unit_code: 'FOO'
      }
      let(:measurement_unit) {
        create :measurement_unit, :with_description,
          description: 'BAR'
      }

      let(:measure_condition) {
        create :measure_condition,
          condition_code: 'L',
          component_sequence_number: 3,
          condition_duty_amount: 108.56,
          condition_monetary_unit_code: monetary_unit.monetary_unit_code,
          condition_measurement_unit_code: measurement_unit.measurement_unit_code,
          condition_measurement_unit_qualifier_code: nil,
          certificate_code: nil,
          certificate_type_code: nil
      }

      it 'returns rendered requirement duty expression' do
        expect(measure_condition.requirement).to eq "108.56 FOO/BAR"
      end
    end
  end

  describe '#document_code' do
    let(:measure_condition) { create :measure_condition, condition_code: 'L', certificate_type_code: '1' }

    it 'contains certificate_type_code' do
      expect(measure_condition.document_code).to include(measure_condition.certificate_type_code)
    end

    it 'contains certificate_code' do
      expect(measure_condition.certificate_code).to include(measure_condition.certificate_code)
    end
  end

  describe '#action' do
    let(:measure_condition) { create :measure_condition, measure_action: create(:measure_action) }

    it 'returns measure_action_description' do
      expect(measure_condition.measure_action).to receive(:description).at_least(1)
      expect(measure_condition.action).to eq(measure_condition.measure_action_description)
    end
  end

  describe '#condition' do
    let(:measure_condition) {
      create :measure_condition, condition_code: '123',
                                     component_sequence_number: 456
    }

    it 'contains condition_code' do
      expect(measure_condition.condition).to include(measure_condition.condition_code)
    end

    it 'contains component_sequence_number' do
      expect(measure_condition.condition).to include(measure_condition.component_sequence_number.to_s)
    end
  end

  describe 'Conformance rules' do
    let!(:measure) { create :measure, validity_start_date: Date.yesterday }
    let!(:certificate) { create :certificate, validity_start_date: Date.yesterday }
    let!(:measure_action) { create :measure_action }

    let(:measure_condition) {
      create(
        :measure_condition,
        measure_sid: measure.measure_sid,
        certificate_type_code: certificate.certificate_type_code,
        certificate_code: certificate.certificate_code,
        action_code: measure_action.action_code
      )
    }

    describe "ME56: The referenced certificate must exist." do
      it "runs validation successfully" do
        expect(measure_condition).to be_conformant
      end

      it "does not run validation successfully" do
        measure_condition.certificate_type_code = "z"
        measure_condition.certificate_type_code = "000"

        expect(measure_condition).not_to be_conformant
        expect(measure_condition.conformance_errors).to have_key(:ME56)
      end
    end

    describe "ME57: The VP of the duty expression must span the VP of the measure." do
      it "runs validation successfully" do
        expect(measure_condition).to be_conformant
      end

      it "does not run validation successfully" do
        measure.validity_start_date = Date.today.ago(5.years)
        measure.validity_end_date   = Date.today.ago(4.years)
        measure.save

        expect(measure_condition).not_to be_conformant
        expect(measure_condition.conformance_errors).to have_key(:ME57)
      end
    end

    describe "ME58: The same certificate can only be referenced once by the same measure and the same condition type." do
      it { is_expected.to validate_uniqueness.of %i[measure_sid certificate_type_code certificate_code] }
    end

    describe "ME59: The referenced action code must exist." do
      it "runs validation successfully" do
        expect(measure_condition).to be_conformant
      end

      it "does not run validation successfully" do
        measure_condition.action_code = "0"

        expect(measure_condition).not_to be_conformant
        expect(measure_condition.conformance_errors).to have_key(:ME59)
      end
    end
  end
end
