require 'rails_helper'

shared_context "regulation_saver_base_context" do

  include_context "form_savers_base_context"

  let(:regulation_saver) do
    ::RegulationSaver.new(user, ops)
  end

  let(:regulation) do
    regulation_saver.regulation
  end

  let(:effective_end_date) do
    validity_end_date + 1.day
  end

  let(:regulation_group) do
    create(:regulation_group)
  end

  let!(:base_regulation) do
    create(:base_regulation,
      base_regulation_role: "1",
      base_regulation_id: "D9402622"
    )
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

  describe "Successful saving" do
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

        attributes_to_check.map do |k, v|
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

    def attributes_to_check
      attrs = regulation_saver.regulation_params

      if [ "CompleteAbrogationRegulation",
           "ExplicitAbrogationRegulation" ].include?(regulation.class.name)
        attrs = attrs.select do |k, v|
          !%w(base_regulation_id base_regulation_role).include?(k)
        end
      end

      attrs
    end
end
