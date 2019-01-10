require 'rails_helper'

shared_context "abrogation_general_regulation_context" do
  describe "Persist" do
    before do
      regulation_saver.valid?
      regulation_saver.persist!

      base_regulation.reload
    end

    it "updates selected base regulation" do
      expect(base_regulation.public_send("#{primary_key_prefix}_role")).to be_eql(
        regulation.public_send("#{primary_key_prefix}_role")
      )

      expect(base_regulation.public_send("#{primary_key_prefix}_id")).to be_eql(
        regulation.public_send("#{primary_key_prefix}_id")
      )
    end
  end
end
