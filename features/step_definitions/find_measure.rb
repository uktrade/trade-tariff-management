

When("I open the Find Measures form") do
  @tarriff_main_menu.find_edit_measure
end

When("I search for a measure") do
  @find_measure_form = FindEditMeasure.new
  @find_measure_form.find_measure "5010950"
end

Then("a result is returned") do
  expect(@find_measure_form).to have_search_result
end

