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
