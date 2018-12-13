require 'rails_helper'

describe MeasureExcludedGeographicalArea do
  describe "Conformance rules" do
    before do
      @geographical_area_group = create(:geographical_area)
      @geographical_area = create(:geographical_area, geographical_code: "1")

      @measure = create(
        :measure,
        geographical_area_sid: @geographical_area.geographical_area_sid,
        geographical_area_id: @geographical_area.geographical_area_id
      )

      @measure_excluded_geographical_area = build(
        :measure_excluded_geographical_area,
        measure: @measure,
        geographical_area: @geographical_area,
        excluded_geographical_area: @geographical_area.geographical_area_id
      )

      @geographical_area_membership = create(
        :geographical_area_membership,
        geographical_area_sid: @geographical_area.geographical_area_sid,
        geographical_area_group_sid: @geographical_area_group.geographical_area_sid,
        validity_start_date: @measure.validity_start_date,
        validity_end_date: @measure.validity_end_date
      )
    end

    describe "ME65: An exclusion can only be entered if the measure is applicable to a geographical area group (area code = 1)." do
      it "runs validation successfully" do
        expect(@geographical_area_membership).to be_conformant
      end

      it "does not run validation successfully" do
        measure_excluded_geographical_area = build(:measure_excluded_geographical_area)
        geographical_area = measure_excluded_geographical_area.measure.geographical_area
        geographical_area.geographical_code = "0"
        geographical_area.save

        expect(measure_excluded_geographical_area).not_to be_conformant
        expect(measure_excluded_geographical_area.conformance_errors).to have_key(:ME65)
      end
    end

    describe "ME66: The excluded geographical area must be a member of the geographical area group." do
      it "runs validation successfully" do
        expect(@measure_excluded_geographical_area).to be_conformant
      end

      it "does not run validation successfully" do
        measure_excluded_geographical_area = build(:measure_excluded_geographical_area,
                                                   excluded_geographical_area: "ab")
        geographical_area = measure_excluded_geographical_area.geographical_area
        geographical_area.geographical_area_id = "xx"
        geographical_area.save

        expect(measure_excluded_geographical_area).not_to be_conformant
        expect(measure_excluded_geographical_area.conformance_errors).to have_key(:ME66)
      end
    end

    # describe "ME67: The membership period of the excluded geographical area must span the validity period of the measure." do
    #   it "should un validation successfully" do
    #     expect(@measure_excluded_geographical_area).to be_conformant
    #   end

    #   it "should not run validation successfully" do
    #     measure = @measure_excluded_geographical_area.measure
    #     measure.validity_start_date = Date.today.ago(5.years)
    #     measure.validity_end_date = Date.today.ago(4.years)
    #     measure.save

    #     expect(@measure_excluded_geographical_area).to_not be_conformant
    #     expect(@measure_excluded_geographical_area.conformance_errors).to have_key(:ME67)
    #   end
    # end

    describe "ME68: The same geographical area can only be excluded once by the same measure." do
      it "runs validation successfully" do
        expect(@measure_excluded_geographical_area).to be_conformant
      end

      it "does not run validation successfully" do
        measure_excluded_geographical_area = create(:measure_excluded_geographical_area)
        measure_excluded_geographical_area2 = measure_excluded_geographical_area.dup

        expect(measure_excluded_geographical_area2).not_to be_conformant
        expect(measure_excluded_geographical_area2.conformance_errors).to have_key(:ME68)
      end
    end
  end
end
