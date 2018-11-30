require "rails_helper"

RSpec.describe "adding measures", :js do
  it "allows news measures to be created" do
    create(:geographical_area, :erga_omnes)
    regulation = create(
      :base_regulation,
      :not_replaced,
      base_regulation_id: "D0399990",
      information_text: "Test regulation",
    )
    measure_type_series = create(:measure_type_series, :with_description)
    measure_type = create(
      :measure_type,
      measure_type_series: measure_type_series,
    )
    commodity = create(:commodity, :declarable)
    create(:user)

    visit(root_path)

    click_on("Create measures")

    input_date("When will these measures come into force?", Date.today)

    within(find("fieldset", text: "Which regulation gives legal force")) do
      search_for_value(type_value: "test", select_value: regulation.information_text)
    end

    select_measure_type_series(measure_type_series)
    select_measure_type(measure_type)

    fill_in("What is the name of this workbasket?", with: "creat-measure-wb")
    fill_in("Goods commodity codes", with: commodity.goods_nomenclature_item_id)

    input_date("Operation date", Date.today)
    select_radio("Erga Omnes")
    click_on("Continue")

    expect(page).to have_content "Specify duties, conditions and footnotes"

    click_on("Continue")

    expect(page).to have_content "Review and submit"
  end

  private

  # TODO: Extract into form helpers?
  def input_date(label, date)
    fill_in(label, with: date.strftime("%d/%m/%Y"))
    close_datepicker
  end

  def close_datepicker
    find("body").click
  end

  def search_for_value(type_value:, select_value:)
    find(".selectize-control input").click.send_keys(type_value)
    find(".selectize-dropdown-content .option", text: select_value).click
  end

  def select_dropdown_value(value)
    find(".selectize-control").click
    find(".selectize-dropdown-content .selection", text: value).click
  end

  def select_radio(label)
    find("label", text: label).click
  end

  def select_measure_type_series(measure_type_series)
    within(".workbasket_forms_create_measures_form_measure_type_series_id") do
      select_dropdown_value(measure_type_series.description)
    end
  end

  def select_measure_type(measure_type)
    within(".workbasket_forms_create_measures_form_measure_type_id") do
      select_dropdown_value(measure_type.description)
    end
  end
end
