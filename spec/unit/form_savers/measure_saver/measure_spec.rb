require "rails_helper"

describe "Measure Saver: Saving of Measure" do

  include_context "measure_saver_base_context"

  describe "Successful saving" do

    let(:ops) do
      base_ops
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

    it "should create new record" do
      expect(measure.reload.new?).to be_falsey

      expect(date_to_s(measure.validity_start_date)).to be_eql(ops[:start_date])
      expect(date_to_s(measure.validity_end_date)).to be_eql(ops[:end_date])
      expect(date_to_s(measure.operation_date)).to be_eql(ops[:operation_date])

      expect(measure.measure_type_id).to be_eql(measure_type.measure_type_id)

      expect(measure.measure_generating_regulation_id).to be_eql(base_regulation.base_regulation_id)
      expect(measure.measure_generating_regulation_role).to be_eql(base_regulation.base_regulation_role)

      expect(measure.justification_regulation_id).to be_eql(base_regulation.base_regulation_id)
      expect(measure.justification_regulation_role).to be_eql(base_regulation.base_regulation_role)

      expect(measure.goods_nomenclature_item_id).to be_eql(commodity.goods_nomenclature_item_id)
      expect(measure.goods_nomenclature_sid).to be_eql(commodity.goods_nomenclature_sid)

      expect(measure.geographical_area_id).to be_eql(geographical_area.geographical_area_id)
      
      expect(measure.additional_code_type_id).to be_eql(additional_code.additional_code_type_id)
      expect(measure.additional_code_sid).to be_eql(additional_code.additional_code_sid)
      expect(measure.additional_code_id).to be_eql(additional_code.additional_code)

      expect(measure.geographical_area_id).to be_eql(geographical_area.geographical_area_id)
      expect(measure.geographical_area_sid).to be_eql(geographical_area.geographical_area_sid)
    end
  end

  describe "Validations" do
    describe "Submit blank form" do
      let(:ops) do
        {}
      end

      it "should NOT be valid" do
        expect(measure_saver.valid?).to be_falsey

        expect(measure_errors[:validity_start_date]).to be_eql("Start date can\'t be blank!")
        expect(measure_errors[:operation_date]).to be_eql("Operation date can\'t be blank!")
      end
    end

    describe "Submit partially filled in form" do
      let(:ops) do
        {
          start_date: date_to_s(validity_start_date),
          operation_date: date_to_s(operation_date)
        }
      end

      it "should NOT be valid" do
        expect(measure_saver.valid?).to be_falsey

        expect(measure_errors[:measure_type_id]).to include("ME2: The measure type must exist.")
        expect(measure_errors[:geographical_area]).to include("ME4: The geographical area must exist.")
        expect(measure_errors[[:measure_generating_regulation_id, :measure_generating_regulation_role]]).to include(
          "ME24: The role + regulation id must exist. If no measure start date is specified it defaults to the regulation start date."
        )
        expect(measure_errors[:measure_generating_regulation_role]).to include(
          "ME86: The role of the entered regulation must be a Base, a Modification, a Provisional Anti-Dumping, a Definitive Anti-Dumping."
        )
      end
    end
  end
end
