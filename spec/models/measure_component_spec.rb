require 'rails_helper'

describe MeasureComponent do
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
    let(:duty_expression_id) { DutyExpression::MEURSING_DUTY_EXPRESSION_IDS.sample }

    let!(:duty_expression)   do
      create(:duty_expression,
             duty_expression_id: duty_expression_id,
             duty_amount_applicability_code: 1,
             monetary_unit_applicability_code: 1,
             measurement_unit_applicability_code: 1
            )
    end

    let!(:measure_component) {
      create(:measure_component,
             measure_sid: measure.measure_sid,
             duty_expression_id: duty_expression.duty_expression_id
            )
    }

    # ME43: The same duty expression can only be used once with the same measure.
    it { should validate_uniqueness.of [:measure_sid, :duty_expression_id] }

    it "valid" do
      expect(measure_component).to be_conformant
    end

    it "ME42: The validity period of the duty expression must span the validity period of the measure." do
      measure.validity_start_date = Date.today.ago(5.years)
      measure.validity_end_date = Date.today.ago(4.years)
      measure.save

      expect(measure_component).to_not be_conformant
      expect(measure_component.conformance_errors).to have_key(:ME42)
    end

    describe "ME45: If the flag 'amount' on duty expression is 'mandatory' then an amount must be specified. If the flag is set 'not permitted' then no amount may be entered." do
      it "handles validation if the flag 'amount' on duty expression is 'mandatory' then an amount must be specified." do
        measure_component.duty_amount = nil
        measure_component.save

        expect(duty_expression.duty_amount_applicability_code).to eq(1)
        expect(measure_component).to_not be_conformant
        expect(measure_component.conformance_errors).to have_key(:ME45)
      end

      it "handles validation if the flag is set 'not permitted' then no amount may be entered." do
        duty_expression.duty_amount_applicability_code = 2
        duty_expression.save

        measure_component.duty_amount = 3.0
        measure_component.save

        expect(measure_component).to_not be_conformant
        expect(measure_component.conformance_errors).to have_key(:ME45)
      end
    end

    describe "ME46: If the flag 'monetary unit' on duty expression is 'mandatory' then a monetary unit must be specified. If the flag is set 'not permitted' then no monetary unit may be entered." do
      it "handles validation if the flag 'monetary unit' on duty expression is 'mandatory' then a monetary unit must be specified" do
        duty_expression.monetary_unit_applicability_code = 1
        duty_expression.save

        measure_component.monetary_unit_code = nil
        measure_component.save

        expect(measure_component).to_not be_conformant
        expect(measure_component.conformance_errors).to have_key(:ME46)
      end

      it "handles validation if the flag is set 'not permitted' then no monetary unit may be entered." do
        duty_expression.monetary_unit_applicability_code = 2
        duty_expression.save

        measure_component.monetary_unit_code = 'BGN'
        measure_component.save

        expect(measure_component).to_not be_conformant
        expect(measure_component.conformance_errors).to have_key(:ME46)
      end
    end

    describe "ME47: If the flag 'measurement unit' on duty expression is 'mandatory' then a measurement unit must be specified. If the flag is set 'not permitted' then no measurement unit may be entered." do
      it "handles validation if the flag 'measurement unit' on duty expression is 'mandatory' then a measurement unit must be specified." do
        duty_expression.measurement_unit_applicability_code = 1
        duty_expression.save

        measure_component.measurement_unit_code = nil
        measure_component.save

        expect(measure_component).to_not be_conformant
        expect(measure_component.conformance_errors).to have_key(:ME47)
      end

      it "handles validation if the flag is set 'not permitted' then no measurement unit may be entered." do
        duty_expression.measurement_unit_applicability_code = 2
        duty_expression.save

        measure_component.measurement_unit_code = 'TNE'
        measure_component.save

        expect(measure_component).to_not be_conformant
        expect(measure_component.conformance_errors).to have_key(:ME47)
      end
    end

    describe "ME41" do
      let!(:duty_expression)   do
        create(:duty_expression,
               duty_expression_id: duty_expression_id,
               duty_amount_applicability_code: 1,
               monetary_unit_applicability_code: 1,
               measurement_unit_applicability_code: 1
              )
      end

      it "should pass validation" do
        expect(measure_component).to be_conformant
        expect(measure_component.conformance_errors).to be_empty
      end

      it "should not pass validation" do
        measure_component = build(:measure_component, duty_expression_id: "987")

        expect(measure_component).to_not be_conformant
        expect(measure_component.conformance_errors).to have_key(:ME41)
      end
    end
  end
end
