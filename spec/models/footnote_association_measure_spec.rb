require 'rails_helper'

describe FootnoteAssociationMeasure do
  describe "validations" do
    describe "conformance rules" do
      let!(:measure) do
        create(
          :measure,
          validity_start_date: Date.yesterday,
          validity_end_date: Date.today + 1.year
        )
      end

      let!(:footnote) do
        create(
          :footnote,
          validity_start_date: Date.yesterday,
          validity_end_date: Date.today + 1.year
        )
      end

      let(:footnote_association_measure) do
        footnote_association_measure = FootnoteAssociationMeasure.new
        footnote_association_measure.measure_sid = measure.measure_sid
        footnote_association_measure.footnote_type_id = footnote.footnote_type_id
        footnote_association_measure.footnote_id = footnote.footnote_id

        footnote_association_measure
      end

      describe "ME69: The associated footnote must exist." do
        it "shoud run validation succesfully" do
          expect(footnote_association_measure).to be_conformant
        end

        it "shoud not run validation succesfully" do
          footnote_association_measure = FootnoteAssociationMeasure.new
          footnote_association_measure.measure_sid = 00000
          footnote_association_measure.footnote_type_id = "00"
          footnote_association_measure.footnote_id = "wrong"

          expect(footnote_association_measure).to_not be_conformant
          expect(footnote_association_measure.conformance_errors).to have_key(:ME69)
        end
      end

      describe "ME70: The same footnote can only be associated once with the same measure." do
        it "shoud not run validation succesfully" do
          footnote_association_measure.save

          footnote_association_measure2 = FootnoteAssociationMeasure.new()
          footnote_association_measure2.measure_sid = footnote_association_measure.measure_sid

          footnote_association_measure2.footnote_type_id = footnote_association_measure.footnote_type_id
          footnote_association_measure2.footnote_id = footnote_association_measure.footnote_id

          expect(footnote_association_measure2).to_not be_conformant
          expect(footnote_association_measure2.conformance_errors).to have_key(:ME70)
        end
      end

      describe "ME73: The validity period of the associated footnote must span the validity period of the measure." do
        it "should run validation successfully" do
          expect(footnote_association_measure).to be_conformant
        end

        it "should not run validation successfully" do
          measure.validity_start_date = Date.today.ago(5.years)
          measure.validity_end_date   = Date.today.ago(4.years)
          measure.save

          expect(footnote_association_measure).to_not be_conformant
          expect(footnote_association_measure.conformance_errors).to have_key(:ME73)
        end
      end
    end
  end
end
