require "rails_helper"

describe "Measure search: date_of filter" do
  include_context "measures_search_base_context"

  let(:search_key) { "date_of" }

  let(:a_measure) do
    create(:measure)
  end

  let(:b_measure) do
    create(:measure)
  end

  let(:c_measure) do
    create(:measure)
  end

  before do
    a_measure
    b_measure
    c_measure
  end

  describe "Valid Search" do
    describe "Mode: authoring" do
      let(:field_name) { :added_at }
      let(:search_mode) { "creation" }

      include_context "measures_search_date_of_context"
    end

    describe "Mode: authoring" do
      let(:field_name) { :added_at }
      let(:search_mode) { "authoring" }

      include_context "measures_search_date_of_context"
    end

    describe "Mode: last status change" do
      let(:field_name) { :last_status_change_at }
      let(:search_mode) { "last_status_change" }

      include_context "measures_search_date_of_context"
    end
  end

  describe "Invalid Search" do
    it "does not filter if value option is blank" do
      res = search_results(
        enabled: true,
        mode: 'creation',
        operator: 'is'
      )

      expect(res.count).to be_eql(3)
    end

    it "does not filter if value and operator options are blank" do
      res = search_results(
        enabled: true,
        mode: 'creation'
      )

      expect(res.count).to be_eql(3)
    end

    it "does not filter with blank options provided" do
      res = search_results({})

      expect(res.count).to be_eql(3)
    end
  end

  private

  def set_date(measure, field_name, value)
    measure.send("#{field_name}=", value)
    measure.save

    measure.reload
  end
end
