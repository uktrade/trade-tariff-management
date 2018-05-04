require "rails_helper"

describe "Measure Saver: Saving of Measure" do

  include_context "form_savers_base_context"

  let(:measure_saver) do
    ::MeasureSaver.new(user, ops)
  end

  let(:measure_errors) do
    measure_saver.errors
  end

  let(:measure) do
    measure_saver.measure
  end

  let!(:base_regulation) do
    create(:base_regulation,
      base_regulation_role: "1",
      base_regulation_id: "D9402622"
    )
  end

  # describe "Successful saving" do
  #   it "should be valid" do
  #     expect(measure_saver.valid?).to be_truthy
  #   end

  #   describe "Persist" do
  #     before do
  #       measure_saver.valid?
  #       measure_saver.persist!
  #     end

  #     it "should create new record" do
  #       expect(regulation.reload.new?).to be_falsey

  #       attributes_to_check.map do |k, v|
  #         expect(value_by_type(regulation.public_send(k)).to_s).to be_eql(v.to_s)
  #       end
  #     end
  #   end
  # end

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

        expect(measure_errors[:measure_type_id]).to include("The measure type must exist.")
        expect(measure_errors[:geographical_area]).to include("The geographical area must exist.")
        expect(measure_errors[[:measure_generating_regulation_id, :measure_generating_regulation_role]]).to include(
          "The role + regulation id must exist. If no measure start date is specified it defaults to the regulation start date."
        )
        expect(measure_errors[:measure_generating_regulation_role]).to include(
          "The role of the entered regulation must be a Base, a Modification, a Provisional Anti-Dumping, a Definitive Anti-Dumping."
        )
      end
    end
  end
end
