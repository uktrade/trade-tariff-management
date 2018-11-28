require "rails_helper"

RSpec.describe WorkbasketServices::MeasureAssociationSavers::ExcludedGeographicalAreas do
  describe "#valid?" do
    it "doesn't insert an extra oplog row for existing measures" do
      measure = create(:measure)
      geographical_area = create(:geographical_area)
      record_ops = { excluded_geographical_area: geographical_area.id}
      saver = described_class.new(measure, {}, record_ops)

      expect { saver.valid? }.
        to_not change{ oplog_count_for_measure(measure) }.from(1)
    end

    it "persists a new measure for reference integrity" do
      measure = build(:measure)
      excluded_geographical_area = create(:geographical_area)
      record_ops = { excluded_geographical_area: excluded_geographical_area.id}
      saver = described_class.new(measure, {}, record_ops)

      expect { saver.valid? }.
        to change{ oplog_count_for_measure(measure) }.from(0).to(1)

      expect(measure.exists?).to be true
    end
  end

  private

  def oplog_count_for_measure(measure)
    Measure::Operation.where(measure_sid: measure.measure_sid).count
  end
end
