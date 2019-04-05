class WorkBasketPage < SitePrism::Page

  section :work_basket_details, :xpath, '//table[@class="create-measures-details-table"][1]' do
    element :workbasket_name, "tr:nth-child(1) td:nth-child(2)"
  end

  section :configuration_summary, :xpath, '//table[@class="create-measures-details-table"][2]' do
    element :regulation, "tr:nth-child(1) td:nth-child(2)"
    element :start_date, "tr:nth-child(2) td:nth-child(2)"
  end

  section :measures_to_be_created, ".records-table-wrapper" do

  end
end