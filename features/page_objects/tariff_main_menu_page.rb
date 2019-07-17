class TariffMainMenuPage < SitePrism::Page

  set_url ENV['BASE_URL']

  element :logout_link, "#log-out", text: "Logout"
  # section :work_baskets, TariffWorkBasketsSection, '.workbaskets .table tbody'
  element :create_measures_link, "#main-menu a", text: "Create measures"
  element :find_edit_measures_link, "#main-menu a", text: "Find and edit measures"
  element :create_quotas_link, "#main-menu a", text: "Create a new quota"
  element :find_edit_quotas_link, "#main-menu a", text: "Find and edit a quota"
  element :find_edit_regulations_link, "#main-menu a", text: "Find and edit regulations"
  element :create_reglutaions_link, "#main-menu a", text: "Create a new regulation"
  element :find_edit_additional_codes_link, "#main-menu a", text: "Find and edit additional codes"
  element :create_additional_codes_link, "#main-menu a", text: "Create new additional codes"
  element :find_edit_geo_areas_link, "#main-menu a", text: "Find and edit geographical areas"
  element :create_geo_areas_link, "#main-menu a", text: "Create a new geographical area"
  element :find_edit_certificates_link, "#main-menu a", text: "Find and edit certificates, licences, documents"
  element :create_certificates_link, "#main-menu a", text: "Create a certificate, licence, or document"
  element :find_edit_footnotes_link, "#main-menu a", text: "Find and edit footnotes"
  element :create_footnotes_link, "#main-menu a", text: "Create a new footnote"
  element :xml_generation_link, "#main-menu a", text: "XML generation"
  element :rollbacks_link, "#main-menu a", text: "Rollbacks"

  element :search_field, "input[name='q']"
  element :search_button, "button.button"

  element :logged_out_message, "#content h1", text: "You have been logged out"

  section :confirmation_modal, ".modal.is-open" do
    element :confirm_button, ".save_progress_block a"
  end

  sections :work_baskets, ".workbaskets .table tbody tr" do
    element :id, "td:nth-child(1)"
    element :name, "td:nth-child(2)"
    element :type, "td:nth-child(3)"
    element :status, "td:nth-child(4)"
    element :last_event, "td:nth-child(5)"
    element :continue, "td:nth-child(6) a", text: "Continue"
    element :delete, "td:nth-child(6) a", text: "Delete"
    element :view, "td:nth-child(6) a", text: "View"
    element :withdraw_edit, "td:nth-child(6) a", text: "Withdraw/edit"
    element :cross_check, "td:nth-child(6) a", text: "Review for cross-check"
    element :approve, "td:nth-child(6) a", text: "Review for approval"
  end

  def open_new_measure_form
    create_measures_link.click
  end

  def open_new_quota_form
    create_quotas_link.click
  end

  def open_new_additional_code_form
    create_additional_codes_link.click
  end

  def logout
    logout_link.click
  end

  def generate_xml
    xml_generation_link.click
  end

  def find_edit_quota
    find_edit_quotas_link.click
    end

  def find_edit_measure
    find_edit_measures_link.click
  end
end
