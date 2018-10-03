require 'rails_helper'

describe MeasurePartialTemporaryStop do
  describe "validation" do
    describe "conformance rules" do
      describe "ME74: The start date of the PTS must be less than or equal to the end date." do
        it "shoud run validation successfully" do
          measure_partial_temporary_stop = MeasurePartialTemporaryStop.new
          measure_partial_temporary_stop.validity_start_date = Date.yesterday
          measure_partial_temporary_stop.validity_end_date = Date.today

          expect(measure_partial_temporary_stop).to be_conformant
        end

        it "shoud not run validation successfully" do
          measure_partial_temporary_stop = MeasurePartialTemporaryStop.new
          measure_partial_temporary_stop.validity_start_date = Date.yesterday + 2.days
          measure_partial_temporary_stop.validity_end_date = Date.today

          expect(measure_partial_temporary_stop).to_not be_conformant
        end
      end
    end
  end
end
