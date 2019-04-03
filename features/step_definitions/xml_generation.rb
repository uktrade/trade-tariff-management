

And(/^I schedule the basket for export$/)do
  @xml_generation_page = XmlGenerationPage.new
  @xml_generation_page.schedule_export @basket_id
  sleep 5
end

And(/^the basket is not scheduled for export$/)do
  expect(@xml_generation_page.work_baskets.map {|basket| basket.id.text}).not_to include(@basket_id)
end

Then(/^the scheduled export status is "([^"]*)"$/) do |status|
  @scheduled_export = find_scheduled_export
  expect(@scheduled_export.status.text).to eq status
end

And(/^the scheduled export has "([^"]*)"$/) do |next_step|
  case next_step
    when 'Review in XML Browser'
      expect(@scheduled_export).to have_review_xml
    when 'Download XML'
      expect(@scheduled_export).to have_download_xml
    when 'Metadata file'
      expect(@scheduled_export).to have_metadata_file
  end
end

And(/^the XML is generated$/) do
  step 'I click on XML generation'
  step 'the scheduled export status is "Completed"'
  step 'the scheduled export has "Review in XML Browser"'
  step 'the scheduled export has "Download XML"'
  step 'the scheduled export has "Metadata file"'
end

def find_scheduled_export
  @baskets = @xml_generation_page.work_baskets.select {|basket| basket.id.text == @basket_id}
  @baskets.pop
end