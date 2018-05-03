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

  let(:ops) do
    {
      validity_start_date: validity_start_date,
      validity_end_date: validity_end_date,
      operation_date: date_to_s(operation_date)
    }
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
  end
end
