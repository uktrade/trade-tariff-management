require "rails_helper"

describe "Saving of Complete abrogation regulation" do

  include_context "regulation_saver_base_context"

  let(:regulation_role) { "6" }
  let(:regulation_class) { CompleteAbrogationRegulation }

  let(:ops) do
    base_ops.merge(
      role: regulation_role,
      base_regulation_id: base_regulation.base_regulation_id,
      base_regulation_role: base_regulation.base_regulation_role,
      published_date: date_to_s(validity_start_date)
    )
  end

  describe "Persist" do
    before do
      regulation_saver.valid?
      regulation_saver.persist!

      base_regulation.reload
    end

    it "should update selected base regulation" do
      expect(base_regulation.complete_abrogation_regulation_role).to be_eql(
        regulation.complete_abrogation_regulation_role
      )

      expect(base_regulation.complete_abrogation_regulation_id).to be_eql(
        regulation.complete_abrogation_regulation_id
      )
    end
  end
end
