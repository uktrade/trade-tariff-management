require 'rails_helper'

describe FootnoteAssociationMeasure do
  describe 'validations' do
    describe 'ME69: The associated footnote must exist.' do
      let!(:measure) { create(:measure) }
      let!(:footnote) { create(:footnote) }

      it "shoud run validation succesfully" do
        footnote_association_measure = FootnoteAssociationMeasure.new(
          measure: measure,
          footnote: footnote,
        )

        expect(footnote_association_measure).to be_conformant
      end

      it "shoud not run validation succesfully" do
        footnote_association_measure = FootnoteAssociationMeasure.new
        footnote_association_measure.measure_sid = "wrong_id"
        footnote_association_measure.footnote_type_id = "00"
        footnote_association_measure.footnote_id = "wrong"

        expect(footnote_association_measure).to_not be_conformant
        expect(footnote_association_measure.conformance_errors).to have_key(:ME69)
      end
    end
  end
end
