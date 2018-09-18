require 'rails_helper'

describe MeasureExcludedGeographicalArea do
  describe "Conformance rules" do
    let!(:measure) { create(:measure) }

    describe "ME65: An exclusion can only be entered if the measure is applicable to a geographical area group (area code = 1)." do
      it "should run validation successfully" do
        measure_excluded_geographical_area = build(:measure_excluded_geographical_area, measure_sid: measure.measure_sid)
        geographical_area = measure_excluded_geographical_area.measure.geographical_area
        geographical_area.geographical_code = "1"
        geographical_area.save

        expect(measure_excluded_geographical_area).to be_conformant
      end

      it "should not run validation successfully" do
        measure_excluded_geographical_area = build(:measure_excluded_geographical_area, measure_sid: measure.measure_sid)
        geographical_area = measure_excluded_geographical_area.measure.geographical_area
        geographical_area.geographical_code = "0"
        geographical_area.save

        expect(measure_excluded_geographical_area).to_not be_conformant
        expect(measure_excluded_geographical_area.conformance_errors).to have_key(:ME65)
      end
    end

    describe "ME66: The excluded geographical area must be a member of the geographical area group." do
      it "should run validation successfully" do
        measure_excluded_geographical_area = build(:measure_excluded_geographical_area,
                                                   measure_sid: measure.measure_sid,
                                                   excluded_geographical_area: "xx")

        geographical_area = measure_excluded_geographical_area.geographical_area
        geographical_area.geographical_code = "1"
        geographical_area.geographical_area_id = "xx"
        geographical_area.save

        geographical_area1 = measure_excluded_geographical_area.measure.geographical_area
        geographical_area1.geographical_code = "1"
        geographical_area1.save

        expect(measure_excluded_geographical_area).to be_conformant
      end

      it "should not run validation successfully" do
        measure_excluded_geographical_area = build(:measure_excluded_geographical_area,
                                                   measure_sid: measure.measure_sid,
                                                   excluded_geographical_area: "ab")


        geographical_area = measure_excluded_geographical_area.geographical_area
        geographical_area.geographical_code = "1"
        geographical_area.geographical_area_id = "xx"
        geographical_area.save

        expect(measure_excluded_geographical_area).to_not be_conformant
        expect(measure_excluded_geographical_area.conformance_errors).to have_key(:ME66)
      end
    end

    describe "ME68: The same geographical area can only be excluded once by the same measure." do
      it "should run validation successfully" do
        measure_excluded_geographical_area = build(:measure_excluded_geographical_area, measure_sid: measure.measure_sid)
        geographical_area = measure_excluded_geographical_area.measure.geographical_area
        geographical_area.geographical_code = "1"
        geographical_area.save

        expect(measure_excluded_geographical_area).to be_conformant
      end

      it "should not run validation successfully" do
        measure_excluded_geographical_area = create(:measure_excluded_geographical_area, measure_sid: measure.measure_sid)
        measure_excluded_geographical_area2 = measure_excluded_geographical_area.dup

        expect(measure_excluded_geographical_area2).to_not be_conformant
        expect(measure_excluded_geographical_area2.conformance_errors).to have_key(:ME68)
      end
    end
  end
end
