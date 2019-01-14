require "rails_helper"

RSpec.describe "adding quotas", :js do
  it 'allows new quotas to be added' do
    create(:geographical_area, :erga_omnes)
    regulation = create(
      :base_regulation,
      :not_replaced,
      base_regulation_id: "D0399990",
      information_text: "Test regulation",
    )
    create(:user)
    measure_type = create(:measure_type, order_number_capture_code: 1)
    create(:measure_type_series_description)
    commodity = create(:commodity, :declarable)
    measurement_unit = create(:measurement_unit, :with_description)
    create(:duty_expression, :with_description, duty_expression_id: "01")
    allow_any_instance_of(Measures::MeasureTypesController).to receive(:collection).and_return([measure_type])
    expect(QuotaOrderNumber.count).to eq 0
    visit(root_path)
    click_on("Create a new quota")

    within(find("fieldset", text: "Which regulation gives legal force")) do
      search_for_value(type_value: "test", select_value: regulation.information_text)
    end

    fill_in :quota_order_number, with: "090909"
    sleep 2

    within(find("fieldset", text: "What is the maximum precision for this quota")) do
      search_for_value(type_value: "3", select_value: "3")
    end

    within(find("fieldset", id: "record_type_dropdown")) do
      find(".selectize-control input").click.send_keys("1")
      select_dropdown_value("1")
    end

    fill_in :quota_description, with: 'test quota description'

    input_date('operation_date', Date.today.beginning_of_year)

    fill_in("Goods commodity codes", with: commodity.goods_nomenclature_item_id)
    select_radio("Erga Omnes")
    click_button('Continue')
    within(find("fieldset", text: "What period type will this section have?")) do
      search_for_value(type_value: "Annual", select_value: "Annual")
    end
    find('#quota-period-year').set('2019')
    within(find("form", text: "How will the quota balance(s) in this section be measured?")) do
      find("#measurement-unit-code").click
      find(".selectize-dropdown-content .selection", text: 'a').click
    end
    find("#annual-opening-balance").set(10000)
    find("#duty-amount").set(10)
    click_button('Continue')
    click_button('Continue')
    expect(page).to have_content 'Review and submit'
    expect(QuotaOrderNumber.count).to eq 1
  end
end
