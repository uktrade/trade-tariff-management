require "rails_helper"

RSpec.describe "management quotas", :js do
  context 'create quota' do
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
      fill_out_configure_quota_form('Annual')
      skip_optional_footnote_form
      expect_to_be_on_submit_for_cross_check_page

      expect(QuotaOrderNumber.count).to eq 1
      expect(Workbaskets::Workbasket.first.title).to eq workbasket_description
    end

    it 'shows quota period type on edit page' do
      create_required_model_instances
      stub_measure_types_controller
      visit_create_quota_page
      fill_out_create_quota_form
      fill_out_configure_quota_form('Annual')
      skip_optional_footnote_form
      expect_to_be_on_submit_for_cross_check_page

      select_quota_to_edit
      fill_out_edit_quota_form
      expect_to_be_on_edit_quota_page

      continue_to_quota_section_page
      expect_quota_period_to_be_populated
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

    fill_in("Goods commodity codes", with: commodity.goods_nomenclature_item_id)
    select_radio("Erga Omnes")
    click_button('Continue')
  end

  def fill_out_configure_quota_form(value)
    within(find("fieldset", text: "What period type will this section have?")) do
      search_for_value(type_value: value, select_value: value)
    end
    input_date("What is the start date of this section?", "01/01/2019".to_date)
    within(find("form", text: "How will the quota balance(s) in this section be measured?")) do
      find("#measurement-unit-code").click
      find(".selectize-dropdown-content .selection", text: measurement_unit.measurement_unit_code).click
    end
    find("#annual-opening-balance").set(10000)
    find('[data-test="duty-amount"]').set(10)
    click_button('Continue')
  end

  def select_quota_to_edit
    visit(root_path)
    click_on('Find and edit a quota')
    all(".multiple-choice").first.click
    all('.find-item__long').first.set(QuotaDefinition.first.quota_order_number_id)
    click_on('Search')
    find("[name='selected_record']").click
    click_on('Work with selected quota')
  end

  def fill_out_edit_quota_form
    find('input.date-picker.form-control').set('01/01/2019')
    find("body").click
    all('.multiple-choice').first.click
    all('.multiple-choice').last.click
    find('#reason').set('testing purposes')
    fill_in 'workbasket_name', with: 'test'
    click_on('Proceed to selected quota')
  end

  def expect_to_be_on_edit_quota_page
    expect(page).to have_content 'Edit quota'
  end

  def skip_optional_footnote_form
    click_button('Continue')
  end

  def expect_to_be_on_submit_for_cross_check_page
    expect(page).to have_content 'Review and submit'
  end

  def continue_to_quota_section_page
    click_on 'Continue'
  end

  def expect_quota_period_to_be_populated
    expect(page).to have_content 'Add a quota section'
    expect(page).to have_content 'Annual'
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
