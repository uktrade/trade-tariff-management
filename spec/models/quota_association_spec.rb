require 'rails_helper'

describe QuotaAssociation do
  describe "validations" do
    describe "conformance rules" do
      let!(:measurement_unit) { create(:measurement_unit) }

      let!(:main_quota_definition) {
        create(
          :quota_definition,
          critical_state: "N",
          measurement_unit_code: measurement_unit.measurement_unit_code,
          volume: 100000.0,
          validity_start_date: Date.today,
          validity_end_date: Date.today + 1.month,
        )
      }

      let!(:sub_quota_definition) {
        create(
          :quota_definition,
          critical_state: "N",
          measurement_unit_code: measurement_unit.measurement_unit_code,
          volume: 80000.0,
          validity_start_date: main_quota_definition.validity_start_date,
          validity_end_date: main_quota_definition.validity_end_date,
        )
      }

      let(:quota_association) {
        qa = described_class.new
        qa.main_quota_definition_sid = main_quota_definition.quota_definition_sid
        qa.sub_quota_definition_sid = sub_quota_definition.quota_definition_sid
        qa
      }

      describe "QA1: The association between two quota definitions must be unique." do
        it "runs validation sucessfully" do
          expect(quota_association).to be_conformant
        end

        it "does not run validation sucessfully" do
          quota_association.save

          quota_association2 = described_class.new
          quota_association2.main_quota_definition_sid = quota_association.main_quota_definition_sid
          quota_association2.sub_quota_definition_sid =  quota_association.sub_quota_definition_sid

          expect(quota_association2).not_to be_conformant
          expect(quota_association2.conformance_errors).to have_key(:QA1)
        end
      end

      describe "QA2: The sub-quota’s validity period must be entirely enclosed within the validity period of the main quota" do
        it "runs validation sucessfully if main quota defintion validation period is same as sub quota validtion period" do
          expect(quota_association).to be_conformant
        end

        it "runs validation sucessfully if sub quota validtion period is within the period of main quota definition" do
          sub_quota_definition.validity_start_date = main_quota_definition.validity_start_date + 1.day
          sub_quota_definition.validity_end_date = main_quota_definition.validity_end_date - 1.day
          sub_quota_definition.save

          qa = described_class.new
          qa.main_quota_definition_sid = main_quota_definition.quota_definition_sid
          qa.sub_quota_definition_sid = sub_quota_definition.quota_definition_sid
          expect(qa).to be_conformant
        end

        it "runs validation sucessfully if sub quota validition end date is nil and main quota validation end date is also nil" do
          main_quota_definition.validity_end_date =  nil
          main_quota_definition.save

          sub_quota_definition.validity_end_date = main_quota_definition.validity_end_date
          sub_quota_definition.save

          qa = described_class.new
          qa.main_quota_definition_sid = main_quota_definition.quota_definition_sid
          qa.sub_quota_definition_sid = sub_quota_definition.quota_definition_sid
          expect(qa).to be_conformant
        end

        it "does not run validation sucessfully sub quota validation period is not within the validation period of main quota" do
          sub_quota_definition.validity_start_date = main_quota_definition.validity_start_date - 1.day
          sub_quota_definition.validity_end_date = main_quota_definition.validity_end_date + 1.day
          sub_quota_definition.save

          qa = described_class.new
          qa.main_quota_definition_sid = main_quota_definition.quota_definition_sid
          qa.sub_quota_definition_sid = sub_quota_definition.quota_definition_sid
          expect(qa).not_to be_conformant
          expect(qa.conformance_errors).to have_key(:QA2)
        end

        it "does not run validation sucessfully sub quota validation period is not within the validation period of main quota" do
          sub_quota_definition.validity_start_date = main_quota_definition.validity_start_date - 1.day
          sub_quota_definition.validity_end_date = main_quota_definition.validity_end_date + 1.day
          sub_quota_definition.save

          qa = described_class.new
          qa.main_quota_definition_sid = main_quota_definition.quota_definition_sid
          qa.sub_quota_definition_sid = sub_quota_definition.quota_definition_sid
          expect(qa).not_to be_conformant
          expect(qa.conformance_errors).to have_key(:QA2)
        end
      end

      describe %(QA3: When converted to the measurement unit of the main quota, the volume of a sub-quota must
               always be lower than or equal to the volume of the main quota.) do

        it "runs validation sucessfully" do
          expect(quota_association).to be_conformant
        end

        it "runs not validation sucessfully" do
          sub_quota_definition.volume = main_quota_definition.volume + 1000
          sub_quota_definition.save

          expect(quota_association).not_to be_conformant
          expect(quota_association.conformance_errors).to have_key(:QA3)
        end
      end
    end
  end
end
