class FindEditQuotaPage < SitePrism::Page

  element :description_field, :xpath, '//div[@class="find-quotas"]//div[@class="find-items__row"][2]/div[@class="find-item__full"]/input'
  element :search_button, "div.form-actions button"
  element :clear, "div.form-actions a"

  sections :quota_search_results, "div.quotas-table div.table__row" do
    element :lock, ".locked-column span i"
    element :select, ".select-all-column input"
    element :order_number, ".quota_order_number_id-column"
    element :type, ".quota_type_id-column"
    element :regulation, ".regulation_id-column"
    element :license, ".license-column"
    element :starts, ".validity_start_date-column"
    element :ends, ".validity_end_date-column"
    element :commodity_codes, ".goods_nomenclature_item_ids-column"
    element :additional_codes, ".additional_code_ids-column"
    element :origin, ".origin-column"
    element :origin_exclusions, ".origin_exclusions-column"
    element :last_updated, ".last_updated-column"
    element :status, ".status-column"
  end

  def find_quota(description)
    description_field.set description
    search_button.click
  end
end