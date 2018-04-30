require 'rails_helper'

shared_context "regulation_saver_base_context" do

  let(:user) do
    create(:user)
  end

  let(:regulation_saver) do
    ::RegulationSaver.new(user, ops)
  end

  let(:regulation) do
    regulation_saver.regulation
  end

  describe "Successful saving" do
    let(:validity_start_date) do
      1.day.from_now
    end

    let(:validity_end_date) do
      validity_start_date + 1.year
    end

    let(:effective_end_date) do
      validity_end_date + 1.day
    end

    let(:operation_date) do
      validity_start_date
    end

    let(:regulation_group) do
      create(:regulation_group)
    end

    let(:base_ops) do
      {
        prefix: "A",
        publication_year: "18",
        regulation_number: "1234",
        number_suffix: "5",
        replacement_indicator: "0",
        information_text: "Info text",
        operation_date: date_to_s(operation_date)
      }
    end

    it "should be valid" do
      expect(regulation_saver.valid?).to be_truthy
    end

    describe "Persist" do
      before do
        regulation_saver.valid?
        regulation_saver.persist!
      end

      it "should create new record" do
        expect(regulation.reload.new?).to be_falsey

        regulation_saver.regulation_params.map do |k, v|

          p ""
          p "!" * 100
          p ""
          p " #{k}: #{v}"
          p ""
          p "!" * 100

          expect(value_by_type(regulation.public_send(k)).to_s).to be_eql(v.to_s)
        end
      end
    end
  end

  describe "Validations" do
    describe "Submit blank form" do
      let(:ops) do
        {
          role: regulation_role
        }
      end

      it "should NOT be valid" do
        expect(regulation_saver.valid?).to be_falsey
      end
    end
  end

  private

    def value_by_type(value)
      case value.class.name
      when "Time", "DateTime", "Date"
        date_to_s(value)
      else
        value
      end
    end

    def date_to_s(date)
      date.strftime("%d/%m/%Y")
    end
end
