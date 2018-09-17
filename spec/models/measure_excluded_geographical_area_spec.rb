require 'rails_helper'

describe MeasureExcludedGeographicalArea do
  describe "Conformance rules" do
    describe "ME65: An exclusion can only be entered if the measure is applicable to a geographical area group (area code = 1)." do
      let!(:measure) { create(:measure) }

      it "should run validation successfully" do
        measure_excluded_geographical_area = build(:measure_excluded_geographical_area, measure_sid: measure.measure_sid)
        geographical_area = measure_excluded_geographical_area.measure.geographical_area
        geographical_area.geographical_code = "1"
        geographical_area.save

        expect(measure_excluded_geographical_area).to be_conformant
      end

      it "should run validation successfully" do
        measure_excluded_geographical_area = build(:measure_excluded_geographical_area, measure_sid: measure.measure_sid)
        geographical_area = measure_excluded_geographical_area.measure.geographical_area
        geographical_area.geographical_code = "0"
        geographical_area.save

        expect(measure_excluded_geographical_area).to_not be_conformant
        expect(measure_excluded_geographical_area.conformance_errors).to have_key(:ME65)
      end
    end
  end
end
