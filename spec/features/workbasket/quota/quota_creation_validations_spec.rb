require "rails_helper"

RSpec.describe "adding quotas", :js do
  context 'validates commodity codes' do
    let!(:measurement_unit) { create(:measurement_unit, :with_description) }

    let(:regulation) do
      regulation = create(
        :base_regulation,
        :not_replaced,
        base_regulation_id: "D0399990",
        information_text: "Test regulation",
      )
    end
    let(:measure_type_series) { create(:measure_type_series_description) }
    let(:measure_type) { create(:measure_type, order_number_capture_code: 1, measure_type_series_id: measure_type_series.measure_type_series_id) }
    let(:measure_type_series_description) do
      create(:measure_type_series_description, measure_type_series_id: measure_type_series.measure_type_series_id)
    end
    let(:commodity) { create(:commodity, :declarable) }
    let(:test_order_number) { '090909' }
    let(:workbasket_description) { "test quota description" }


    it 'creates new quota order number ' do
      create_required_model_instances
      stub_measure_types_controller

      expect(QuotaOrderNumber.count).to eq 0

      visit_create_quota_page
      fill_out_create_quota_form
      fill_out_configure_quota_form

      expect(page).to have_content 'The following commodity codes are incorrect, please check: ["Bananas", "Widgets"]'
    end
  end


  def visit_create_quota_page
    visit(root_path)
    click_on("Create a new quota")
  end

  def fill_out_create_quota_form
    within(find("fieldset", text: "Which regulation gives legal force")) do
      search_for_value(type_value: "test", select_value: regulation.information_text)
    end

    fill_in :quota_order_number, with: test_order_number

    within(find("fieldset", text: "What is the maximum precision for this quota")) do
      search_for_value(type_value: "3", select_value: "3")
    end

    within(find("fieldset", id: "record_type_dropdown")) do
      find(".selectize-control input").click.send_keys(measure_type.measure_type_id)
      select_dropdown_value(measure_type.measure_type_id)
    end

    fill_in :quota_description, with: workbasket_description

    input_date('operation_date', Date.today.beginning_of_year)

    fill_in("Goods commodity codes", with: "Bananas, #{commodity.goods_nomenclature_item_id}, Widgets")
    select_radio("Erga Omnes")
    click_button('Continue')
  end

  def fill_out_configure_quota_form
    within(find("fieldset", text: "What period type will this section have?")) do
      search_for_value(type_value: "Annual", select_value: "Annual")
    end
    fill_in('What is the start date of this section?', with: '01/01/2019')
    within(find("form", text: "How will the quota balance(s) in this section be measured?")) do
      find("#measurement-unit-code").click
      find(".selectize-dropdown-content .selection", text: measurement_unit.measurement_unit_code).click
    end
    find("#annual-opening-balance").set(10000)
    find('[data-test="duty-amount"]').set(10)
    click_button('Continue')
  end

  def skip_optional_footnote_form
    click_button('Continue')
  end

  def expect_to_be_on_submit_for_cross_check_page
    expect(page).to have_content 'Review and submit'
  end

  def create_required_model_instances
    create(:geographical_area, :erga_omnes)
    create(:user)
    create(:duty_expression, :with_description, duty_expression_id: "01")
  end

  def stub_measure_types_controller
    allow_any_instance_of(Measures::MeasureTypesController).to receive(:collection).and_return([measure_type])
  end
end
