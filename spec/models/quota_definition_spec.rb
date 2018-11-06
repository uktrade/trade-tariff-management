require 'rails_helper'

describe QuotaDefinition do
  describe '#status' do
    context 'quota events present' do
    end

    context 'quota events absent' do
      it 'returns Open if quota definition is not in critical state' do
        quota_definition = build :quota_definition, critical_state: 'N'
        expect(quota_definition.event_status).to eq 'Open'
      end

      it 'returns Critical if quota definition is in critical state' do
        quota_definition = build :quota_definition, critical_state: 'Y'
        expect(quota_definition.event_status).to eq 'Critical'
      end
    end
  end

  describe "#validations" do
    describe "#conformance rules" do
      let!(:quota_order_number) { create(:quota_order_number) }
      let!(:monetary_unit) { create(:monetary_unit, monetary_unit_code: "EUR") }
      let!(:measurement_unit) { create(:measurement_unit) }
      let!(:measurement_unit_qualifier) { create(:measurement_unit_qualifier) }

      let(:quota_definition) {
        build(
          :quota_definition,
          quota_order_number: quota_order_number,
          monetary_unit_code: monetary_unit.monetary_unit_code,
          measurement_unit_code: measurement_unit.measurement_unit_code,
          measurement_unit_qualifier_code: measurement_unit_qualifier.measurement_unit_qualifier_code,
          critical_state: "N",
          validity_start_date: Date.today,
          validity_end_date: Date.today + 1.day,
        )
      }

      describe "QD1: Quota order number id + start date must be unique" do
        it "should run validation sucessfully" do
          expect(quota_definition).to be_conformant
        end

        it "should not run validation sucessfully" do
          quota_definition = create(
            :quota_definition,
            quota_order_number_id: quota_order_number.quota_order_number_id,
            critical_state: "N",
            validity_start_date: Date.today,
            validity_end_date: Date.today + 1.day,
          )

          new_quota_definition = build(:quota_definition)
          new_quota_definition.quota_order_number_id = quota_definition.quota_order_number_id
          new_quota_definition.quota_order_number_sid = quota_definition.quota_order_number_sid
          new_quota_definition.validity_start_date = quota_definition.validity_start_date
          new_quota_definition.validity_end_date = quota_definition.validity_end_date

          expect(new_quota_definition).to_not be_conformant
          expect(new_quota_definition.conformance_errors).to have_key(:QD1)
        end
      end

      describe "QD2: The start date must be less than or equal to the end date" do
        it "should run validation sucessfully" do
          expect(quota_definition).to be_conformant
        end

        it "should not run validation sucessfully" do
          quota_definition.validity_start_date = Date.today
          quota_definition.validity_end_date = Date.yesterday

          expect(quota_definition).to_not be_conformant
          expect(quota_definition.conformance_errors).to have_key(:QD2)
        end
      end

      describe "QD3: The quota order number must exist." do
        it "should run validation sucessfully" do
          expect(quota_definition).to be_conformant
        end

        it "should not run validation sucessfully" do
          quota_definition = build(
            :quota_definition,
            quota_order_number_id: 0,
            critical_state: "N",
            validity_start_date: Date.today,
            validity_end_date: Date.today + 1.day,
          )

          expect(quota_definition).to_not be_conformant
          expect(quota_definition.conformance_errors).to have_key(:QD3)
        end
      end

      describe "QD4: The monetary unit code must exist." do
        it "should pass validation" do
          expect(quota_definition).to be_conformant
          expect(quota_definition.conformance_errors).to be_empty
        end

        it "should not pass validation" do
          quota_definition.monetary_unit_code = 0

          expect(quota_definition).to_not be_conformant
          expect(quota_definition.conformance_errors).to have_key(:QD4)
        end
      end

      describe "QD5: The monetary unit code must exist." do
        it "should pass validation" do
          expect(quota_definition).to be_conformant
          expect(quota_definition.conformance_errors).to be_empty
        end

        it "should not pass validation" do
          quota_definition.measurement_unit_code = 0

          expect(quota_definition).to_not be_conformant
          expect(quota_definition.conformance_errors).to have_key(:QD5)
        end
      end

      describe "QD6: The measurement unit qualifier code must exist." do
        it "should pass validation" do
          expect(quota_definition).to be_conformant
          expect(quota_definition.conformance_errors).to be_empty
        end

        it "should not pass validation" do
          quota_definition.measurement_unit_qualifier_code = 0

          expect(quota_definition).to_not be_conformant
          expect(quota_definition.conformance_errors).to have_key(:QD6)
        end
      end

      describe %(QD7: The validity period of the quota definition must be spanned by one
        of the validity periods of the referenced quota order number.) do

        it "should pass validation" do
          expect(quota_definition).to be_conformant
          expect(quota_definition.conformance_errors).to be_empty
        end

        it "should not pass validation" do
          quota_order_number = quota_definition.quota_order_number
          quota_order_number.validity_start_date = quota_definition.validity_start_date - 5.years
          quota_order_number.validity_end_date =  quota_definition.validity_start_date - 4.years
          quota_order_number.save

          expect(quota_definition).to_not be_conformant
          expect(quota_definition.conformance_errors).to have_key(:QD7)
        end
      end

      describe %(QD8: The validity period of the monetary unit code must span the validity period of the quota definition.) do

        it "should pass validation" do
          expect(quota_definition).to be_conformant
          expect(quota_definition.conformance_errors).to be_empty
        end

        it "should not pass validation" do
          monetary_unit = quota_definition.monetary_unit
          monetary_unit.validity_start_date = quota_definition.validity_start_date - 5.years
          monetary_unit.validity_end_date =  quota_definition.validity_start_date - 4.years
          monetary_unit.save

          expect(quota_definition).to_not be_conformant
          expect(quota_definition.conformance_errors).to have_key(:QD8)
        end
      end

      describe %(QD9: The monetary unit code must always be the Euro ISO code (or Euc for quota defined prior to the Euro Definition).) do
        it "should pass validation" do
          expect(quota_definition.monetary_unit_code).to eq("EUR")
          expect(quota_definition).to be_conformant
          expect(quota_definition.conformance_errors).to be_empty

          quota_definition.monetary_unit_code = "EUC"
          expect(quota_definition.monetary_unit_code).to eq("EUC")
          expect(quota_definition).to be_conformant
          expect(quota_definition.conformance_errors).to be_empty
        end

        it "should not pass validation" do
          quota_definition.monetary_unit_code = "LTS"

          expect(quota_definition).to_not be_conformant
          expect(quota_definition.conformance_errors).to have_key(:QD9)
        end
      end

      describe %(QD10: The validity period of the measurement unit code must span the validity period of the quota definition.) do
        it "should pass validation" do
          expect(quota_definition).to be_conformant
          expect(quota_definition.conformance_errors).to be_empty
        end

        it "should not pass validation" do
          measurement_unit = quota_definition.measurement_unit
          measurement_unit.validity_start_date = quota_definition.validity_start_date - 5.years
          measurement_unit.validity_end_date =  quota_definition.validity_start_date - 4.years
          measurement_unit.save

          expect(quota_definition).to_not be_conformant
          expect(quota_definition.conformance_errors).to have_key(:QD10)
        end
      end

      describe %(QD11: The validity period of the measurement unit qualifier code must span the validity period of the quota definition.) do
        it "should pass validation" do
          expect(quota_definition).to be_conformant
          expect(quota_definition.conformance_errors).to be_empty
        end

        it "should not pass validation" do
          measurement_unit_qualifier = quota_definition.measurement_unit_qualifier
          measurement_unit_qualifier.validity_start_date = quota_definition.validity_start_date - 5.years
          measurement_unit_qualifier.validity_end_date =  quota_definition.validity_start_date - 4.years
          measurement_unit_qualifier.save

          expect(quota_definition).to_not be_conformant
          expect(quota_definition.conformance_errors).to have_key(:QD11)
        end
      end
    end
  end
end
