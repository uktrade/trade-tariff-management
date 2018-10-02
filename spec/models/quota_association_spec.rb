require 'rails_helper'

describe QuotaAssociation do
  describe "validations" do
    describe "conformance rules" do
      describe "QA1: The association between two quota definitions must be unique." do
        it "should run validation sucessfully" do
          qa = QuotaAssociation.new
          qa.main_quota_definition_sid = 1
          qa.sub_quota_definition_sid = 1

          expect(qa).to be_conformant
        end

        it "should not run validation sucessfully" do
          qa = QuotaAssociation.new
          qa.main_quota_definition_sid = 1
          qa.sub_quota_definition_sid = 1
          qa.save

          qa2 = QuotaAssociation.new
          qa2.main_quota_definition_sid = 1
          qa2.sub_quota_definition_sid = 1

          expect(qa2).to_not be_conformant
          expect(qa2.conformance_errors).to have_key(:QA1)
        end
      end
    end
  end
end
