require 'rails_helper'

describe MeasureConditionComponent do
  describe 'associations' do
    describe 'duty expression' do
      it_is_associated 'one to one to', :duty_expression do
        let(:duty_expression_id) { Forgery(:basic).text(exactly: 3) }
      end
    end

    describe 'measurement unit' do
      it_is_associated 'one to one to', :measurement_unit do
        let(:measurement_unit_code) { Forgery(:basic).text(exactly: 3) }
      end
    end

    describe 'monetary unit' do
      it_is_associated 'one to one to', :monetary_unit do
        let(:monetary_unit_code) { Forgery(:basic).text(exactly: 3) }
      end
    end

    describe 'measurement unit qualifier' do
      it_is_associated 'one to one to', :measurement_unit_qualifier do
        let(:measurement_unit_qualifier_code) { Forgery(:basic).text(exactly: 1) }
      end
    end
  end

  describe 'Conformance rules' do
    let!(:measure)           { create :measure }
    let!(:measure_condition) { create :measure_condition, measure_sid: measure.measure_sid }
    let!(:monetary_unit) { create :monetary_unit }
    let!(:measurement_unit) { create :measurement_unit }
    let!(:measurement_unit_qualifier) { create :measurement_unit_qualifier }

    let!(:duty_expression) do
      create(:duty_expression,
             duty_expression_id: "01",
             duty_amount_applicability_code: 1,
             monetary_unit_applicability_code: 1,
             measurement_unit_applicability_code: 1)
    end

    let!(:duty_expression_description) { create :duty_expression_description, duty_expression_id: duty_expression.duty_expression_id }

    let!(:measure_condition_component) do
      create(
        :measure_condition_component,
        measure_condition_sid: measure_condition.measure_condition_sid,
        duty_expression_id: duty_expression.duty_expression_id,
        monetary_unit_code: monetary_unit.monetary_unit_code,
        measurement_unit_code: measurement_unit.measurement_unit_code,
        measurement_unit_qualifier_code: measurement_unit_qualifier.measurement_unit_qualifier_code
      )
    end

    it "valid" do
      expect(measure_condition_component).to be_conformant
    end

    describe "ME53: The referenced measure condition must exist." do
      it "should pass validation" do
        expect(measure_condition_component).to be_conformant
        expect(measure_condition_component.conformance_errors).to be_empty
      end

      it "should not pass validation" do
        measure_condition_component.measure_condition_sid = 0
        measure_condition_component.save

        allow_any_instance_of(TradeTariffBackend::Validations::ValidityDateSpanValidation)
          .to receive(:valid?).and_return(true)

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME53)
      end
    end

    describe "ME60: The referenced monetary unit must exist." do
      it "should pass validation" do
        expect(measure_condition_component).to be_conformant
        expect(measure_condition_component.conformance_errors).to be_empty
      end

      it "should not pass validation" do
        measure_condition_component.monetary_unit_code = 0

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME60)
      end
    end

    it "ME61: The validity period of the referenced monetary unit must span the validity period of the measure." do
      measure.validity_start_date = Date.today.ago(5.years)
      measure.validity_end_date = Date.today.ago(4.years)
      measure.save

      expect(measure_condition_component).to_not be_conformant
      expect(measure_condition_component.conformance_errors).to have_key(:ME61)
    end

    describe "ME62: The combination measurement unit + measurement unit qualifier must exist." do
      it "should run validation successfully" do
        expect(measure_condition_component).to be_conformant
      end

      it "should not run validation successfully" do
        measure_condition_component.measurement_unit_code = "0"
        measure_condition_component.measurement_unit_qualifier_code = "0"

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME62)
      end
    end

    describe "ME63: The validity period of the measurement unit must span the validity period of the measure." do
      it "should un validation successfully" do
        expect(measure_condition_component).to be_conformant
      end

      it "should not run validation successfully" do
        measurement_unit = measure_condition_component.measurement_unit
        measurement_unit.validity_start_date = Date.today.ago(5.years)
        measurement_unit.validity_end_date = Date.today.ago(4.years)
        measurement_unit.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME63)
      end
    end

    describe "ME64: The validity period of the measurement unit qualifier must span the validity period of the measure." do
      it "should un validation successfully" do
        expect(measure_condition_component).to be_conformant
      end

      it "should not run validation successfully" do
        measurement_unit_qualifier = measure_condition_component.measurement_unit_qualifier
        measurement_unit_qualifier.validity_start_date = Date.today.ago(5.years)
        measurement_unit_qualifier.validity_end_date = Date.today.ago(4.years)
        measurement_unit_qualifier.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME64)
      end
    end

    it "ME105: The reference duty expression must exist" do
      measure_condition_component.duty_expression_id = nil
      measure_condition_component.save

      expect(measure_condition_component).to_not be_conformant
      expect(measure_condition_component.conformance_errors).to have_key(:ME105)
    end

    it "ME106: The VP of the duty expression must span the VP of the measure." do
      measure.validity_start_date = Date.today.ago(5.years)
      measure.validity_end_date = Date.today.ago(4.years)
      measure.save

      expect(measure_condition_component).to_not be_conformant
      expect(measure_condition_component.conformance_errors).to have_key(:ME106)
    end

    context "for more than one measure contidion component" do
      let(:duty_expression_id2) { "02" }
      let(:duty_expression_id3) { "04" }

      let!(:duty_expression2)   do
        create(
          :duty_expression,
          duty_expression_id: duty_expression_id2,
          duty_amount_applicability_code: 1,
          monetary_unit_applicability_code: 1,
          measurement_unit_applicability_code: 1
        )
      end

      let!(:duty_expression3) do
        create(
          :duty_expression,
          duty_expression_id: duty_expression_id3,
          duty_amount_applicability_code: 1,
          monetary_unit_applicability_code: 1,
          measurement_unit_applicability_code: 1
        )
      end

      let!(:duty_expression_description2) { create :duty_expression_description, duty_expression_id: duty_expression_id2 }
      let!(:duty_expression_description3) { create :duty_expression_description, duty_expression_id: duty_expression_id3 }

      let!(:measure_condition_component2) do
        create(
          :measure_condition_component,
          measure_condition_sid: measure_condition.measure_condition_sid,
          duty_expression_id: duty_expression2.duty_expression_id
        )
      end

      let!(:measure_condition_component3) do
        create(
          :measure_condition_component,
          measure_condition_sid: measure_condition.measure_condition_sid,
          duty_expression_id: duty_expression3.duty_expression_id,
          monetary_unit_code: monetary_unit.monetary_unit_code,
          measurement_unit_code: measurement_unit.measurement_unit_code,
          measurement_unit_qualifier_code: measurement_unit_qualifier.measurement_unit_qualifier_code
        )
      end

      it "valid" do
        expect(measure_condition_component3).to be_conformant
      end
    end

    # "ME108: The same duty expression can only be used once within condition components of the same condition of the same measure. (i.e. it can be re-used in other conditions, no matter what condition type, of the same measure)"
    it { should validate_uniqueness.of %i[measure_condition_sid duty_expression_id] }

    describe "Flag 'amount' on duty expression is mandatory" do
      it "ME109: If the flag 'amount' on duty expression is 'mandatory' then an amount must be specified. If the flag is set to 'not permitted' then no amount may be entered." do
        measure_condition_component.duty_amount = nil
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME109)
      end
    end

    describe "Flag 'amount' on duty expression is not permitted" do
      it "ME109: If the flag 'amount' on duty expression is 'mandatory' then an amount must be specified. If the flag is set to 'not permitted' then no amount may be entered." do
        duty_expression.duty_amount_applicability_code = 2
        duty_expression.save

        measure_condition_component.duty_amount = 3.0
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME109)
      end
    end

    describe "Flag 'monetary unit' on duty expression is mandatory" do
      it "ME110: If the flag 'monetary unit' on duty expression is 'mandatory' then a monetary unit must be specified. If the flag is set to 'not permitted' then no monetary unit may be entered." do
        duty_expression.monetary_unit_applicability_code = 1
        duty_expression.save

        measure_condition_component.monetary_unit_code = nil
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME110)
      end
    end

    describe "Flag 'monetary unit' on duty expression is not permitted" do
      it "ME110: If the flag 'monetary unit' on duty expression is 'mandatory' then a monetary unit must be specified. If the flag is set to 'not permitted' then no monetary unit may be entered." do
        duty_expression.monetary_unit_applicability_code = 2
        duty_expression.save

        measure_condition_component.monetary_unit_code = 'BGN'
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME110)
      end
    end

    describe "Flag 'measurement unit' on duty expression is mandatory" do
      it "ME111: If the flag 'measurement unit' on duty expression is 'mandatory' then a measurement unit must be specified. If the flag is set to 'not permitted' then no measurement unit may be entered." do
        duty_expression.measurement_unit_applicability_code = 1
        duty_expression.save

        measure_condition_component.measurement_unit_code = nil
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME111)
      end
    end

    describe "Flag 'measurement unit' on duty expression is not permitted" do
      it "ME111: If the flag 'measurement unit' on duty expression is 'mandatory' then a measurement unit must be specified. If the flag is set to 'not permitted' then no measurement unit may be entered." do
        duty_expression.measurement_unit_applicability_code = 2
        duty_expression.save

        measure_condition_component.measurement_unit_code = 'TNE'
        measure_condition_component.save

        expect(measure_condition_component).to_not be_conformant
        expect(measure_condition_component.conformance_errors).to have_key(:ME111)
      end
    end
  end
end
