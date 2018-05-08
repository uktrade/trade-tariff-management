require "rails_helper"

describe "Measure Saver: Saving of Footnotes" do

  include_context "measure_saver_base_context"

  let(:footnotes) do
    measure.reload
           .footnotes
  end

  before do
    base_regulation
    measure_type
    additional_code
    geographical_area
    commodity

    measure_saver.valid?
    measure_saver.persist!
  end

  describe "Invalid params" do
    let(:ops) do
      base_ops.merge(
        footnotes: {
          "0" => {
            "footnote_type_id"=>"CA",
            "description"=>""
          },
          "1" => {
            "footnote_type_id"=>"CG",
            "description"=>""
          }
        }
      )
    end

    it "should not create new footnotes" do
      expect(measure.reload.new?).to be_falsey

      expect(Footnote.count).to be_eql(0)
      expect(footnotes.size).to be_eql(0)
    end
  end

  describe "Successful saving" do
    let(:ops) do
      base_ops.merge(
        footnotes: {
          "0" => {
            "footnote_type_id"=>"CA",
            "description"=>"TEST"
          },
          "1" => {
            "footnote_type_id"=>"CG",
            "description"=>"TEST 2"
          }
        }
      )
    end

    it "should create and associate footnotes with measure" do
      expect(measure.reload.new?).to be_falsey

      expect(Footnote.count).to be_eql(2)
      expect(FootnoteDescription.count).to be_eql(2)
      expect(FootnoteDescriptionPeriod.count).to be_eql(2)
      expect(FootnoteAssociationMeasure.count).to be_eql(2)

      expect_footnote_to_be_valid(footnotes[0], "CA", "TEST")
      expect_footnote_to_be_valid(footnotes[1], "CG", "TEST 2")
    end
  end

  private

    def expect_footnote_to_be_valid(footnote, footnote_type_id, description)
      expect(footnote.footnote_id).not_to be_nil
      expect(footnote.footnote_type_id).to be_eql(footnote_type_id)
      expect(footnote.description).to be_eql(description)

      expect(date_to_s(footnote.validity_start_date)).to be_eql(
        date_to_s(measure.validity_start_date)
      )
      expect(date_to_s(footnote.validity_end_date)).to be_eql(
        date_to_s(measure.validity_end_date)
      )
      expect(date_to_s(footnote.operation_date)).to be_eql(
        date_to_s(measure.operation_date)
      )

      expect(footnote.added_at).not_to be_nil
      expect(footnote.added_by_id).to be_eql(user.id)
    end
end
