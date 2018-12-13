require 'rails_helper'

shared_context "regulation_saver_base_context" do
  include_context "form_savers_base_context"

  let(:workbasket) do
    ::Workbaskets::Workbasket::buld_new_workbasket!(:create_regulation, user)
  end

  let(:regulation_saver) do
    ::WorkbasketInteractions::CreateRegulation::SettingsSaver.new(
      workbasket, 'main', 'continue', ops
    )
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
      base_regulation_id: "D9402622")
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
    it "is valid" do
      expect(regulation_saver).to be_valid
    end

    describe "Persist" do
      before do
        regulation_saver.valid?
        regulation_saver.persist!
      end

      it "creates new record" do
        expect(regulation.reload).not_to be_new

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

      it "is not valid" do
        expect(regulation_saver).not_to be_valid
      end
    end
  end

  private

  def attributes_to_check
    attrs = regulation_saver.filtered_ops

    if %w[CompleteAbrogationRegulation
          ExplicitAbrogationRegulation].include?(regulation.class.name)
      attrs = attrs.reject do |k, _v|
        %w(base_regulation_id base_regulation_role).include?(k)
      end
    end

    attrs
  end
end
