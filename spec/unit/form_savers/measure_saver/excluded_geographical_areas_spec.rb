require "rails_helper"

describe "Measure Saver: Saving of Excluded geographical areas" do

  include_context "measure_saver_base_context"

  let(:excluded_geographical_areas) do
    measure.reload
           .excluded_geographical_areas
  end

  let(:measure_excluded_geographical_areas) do
    MeasureExcludedGeographicalArea.all
  end

  let(:ae_area) do
    create(:geographical_area,
      geographical_area_id: "AE",
      validity_start_date: 1.year.ago
    )
  end

  let(:ag_area) do
    create(:geographical_area,
      geographical_area_id: "AG",
      validity_start_date: 1.year.ago
    )
  end

  before do
    base_regulation
    measure_type
    additional_code
    geographical_area
    ae_area
    ag_area
    commodity

    measure_saver.valid?
    measure_saver.persist!
  end

  describe "Successful saving" do
    let(:ops) do
      base_ops.merge(
        geographical_area_id: geographical_area.geographical_area_id,
        excluded_geographical_areas: [
          ae_area.geographical_area_id, ag_area.geographical_area_id
        ]
      )
    end

    it "should create and associate excluded geographical areas with measure" do
      expect(measure.reload.new?).to be_falsey

      expect(measure_excluded_geographical_areas.count).to be_eql(2)

      expect_measure_excluded_geographical_area_to_be_valid(
        measure_excluded_geographical_areas[0], ae_area
      )
      expect_measure_excluded_geographical_area_to_be_valid(
        measure_excluded_geographical_areas[1], ag_area
      )

      expect_excluded_geographical_area_to_be_valid(excluded_geographical_areas[0], ae_area)
      expect_excluded_geographical_area_to_be_valid(excluded_geographical_areas[1], ag_area)
    end
  end

  private

    def expect_measure_excluded_geographical_area_to_be_valid(record, area)
      expect(record.measure_sid).to be_eql(measure.measure_sid)
      expect(record.excluded_geographical_area).to be_eql(area.geographical_area_id)
      expect(record.geographical_area_sid).to be_eql(area.geographical_area_sid)

      expect(date_to_s(record.operation_date)).to be_eql(
        date_to_s(measure.operation_date)
      )

      expect(record.added_at).not_to be_nil
      expect(record.added_by_id).to be_eql(user.id)
    end

    def expect_excluded_geographical_area_to_be_valid(record, area)
      expect(record.geographical_area_id).to be_eql(area.geographical_area_id)
      expect(record.geographical_area_sid).to be_eql(area.geographical_area_sid)
    end
end
