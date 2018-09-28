require 'rails_helper'

describe QuotaDefinition do
  describe '#status' do
    context 'quota events present' do
    end

    context 'quota events absent' do
      it 'returns Open if quota definition is not in critical state' do
        quota_definition = build :quota_definition, critical_state: 'N'
        expect(quota_definition.status).to eq 'Open'
      end

      it 'returns Critical if quota definition is in critical state' do
        quota_definition = build :quota_definition, critical_state: 'Y'
        expect(quota_definition.status).to eq 'Critical'
      end
    end
  end

  describe "#validations" do
    describe "#conformance rules" do

      describe "QD1: Quota order number id + start date must be unique" do
        it "should run validation sucessfully" do
          quota_definition = build(
            :quota_definition,
            critical_state: 'N',
            validity_start_date: Date.today,
            validity_end_date: Date.today + 1.day,
          )

          expect(quota_definition).to be_conformant
        end

        it "should not run validation sucessfully" do
          quota_definition = create(
            :quota_definition,
            critical_state: 'N',
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
          quota_definition = build(
            :quota_definition,
            critical_state: 'N',
            validity_start_date: Date.yesterday,
            validity_end_date: Date.today,
          )

          expect(quota_definition).to be_conformant
        end

        it "should not run validation sucessfully" do
          quota_definition = build(
            :quota_definition,
            critical_state: 'N',
            validity_start_date: Date.today,
            validity_end_date: Date.yesterday,
          )

          expect(quota_definition).to_not be_conformant
          expect(quota_definition.conformance_errors).to have_key(:QD2)
        end
      end

    end
  end
end
