require "rails_helper"

RSpec.describe "adding footnotes", :js do

  # Reference data required for Footnote Type selector
  let(:footnote_type) { create(:footnote_type) }
  let!(:footnote_type_description) { create(:footnote_type_description, footnote_type_id: footnote_type.footnote_type_id) }

  let(:footnote_description) { "A foot is 12 inches long." }
  let(:footnote_valid_from) { Date.today }

  it "allows a new footnote to be created" do

    visit(root_path)
    click_on("Create a new footnote")

    within(find("fieldset", text: "What type of footnote is this?")) do
      select_dropdown_value(footnote_type.footnote_type_id)
    end

    fill_in("What is the footnote description?", with: footnote_description)
    input_date_gds("#validity_start_date", footnote_valid_from)

    click_on "Submit for cross-check"

    expect(page).to have_content("has been submitted for cross-check.")
    expect(Footnote.last).to have_attributes(description: footnote_description,
                                             validity_start_date: footnote_valid_from)
  end

end
