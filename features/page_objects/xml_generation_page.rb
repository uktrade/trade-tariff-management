class XmlGenerationPage < SitePrism::Page

  element :workbasket_id_field, "#export_workbasket_id"
  element :schedule_export_button, "input[value^='Schedule']"

  sections :work_baskets, ".table tbody tr" do
    element :id, "td:nth-child(1)"
    element :scheduled_at, "td:nth-child(2)"
    element :status, "td:nth-child(3)"
    element :review_xml, "td:nth-child(4) a", text: "Review in XML Browser"
    element :download_xml, "td:nth-child(4) a", text: "Download XML"
    element :metadata_file, "td:nth-child(4) a", text: "Metadata file"
  end

  def schedule_export(basket_id)
    workbasket_id_field.set basket_id
    schedule_export_button.click
  end
end