require 'rails_helper'
include WorkbasketHelper

RSpec.describe(Workbaskets::Workbasket) do
  describe "#move_status_to!" do
    it "resets all steps_passed in the workbasket settings" do

      user = create(:user)
      workbasket = create(:workbasket, :create_measures)
      workbasket.settings.main_step_validation_passed = true
      workbasket.settings.duties_conditions_footnotes_step_validation_passed = true
      workbasket.settings.save

      decorated_basket = workbasket.decorate

      expect(decorated_basket.settings.duties_conditions_footnotes_step_validation_passed).to be true
      workbasket.move_status_to!(user, "editing")
      expect(decorated_basket.settings.duties_conditions_footnotes_step_validation_passed).to be false
    end
  end
end
