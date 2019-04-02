class TariffMainMenuPage < SitePrism::Page

  set_url ENV['BASE_URL']

  # section :work_baskets, TariffWorkBasketsSection, '.workbaskets .table tbody'
  element :create_measures_link, "#main-menu div:nth-child(7) a[href$='/new']"
  element :find_edit_measures_link, "#main-menu div:nth-child(7) a[href$='/measure']"
  element :create_quotas_link, "#main-menu div:nth-child(8) a[href$='/new']"
  element :find_edit_quotas_link, "#main-menu div:nth-child(8) a[href$='/quotas']"
  element :find_edit_regulations_link, ""
  element :create_reglutaions_link, ""
  element :find_edit_additional_codes_link, ""
  element :create_additional_codes_link, ""
  element :find_edit_geo_areas_link, ""
  element :create_geo_areas_link, ""
  element :find_edit_certificates_link, ""
  element :create_certificates_link, ""
  element :find_edit_footnotes_link, ""
  element :create_footnotes_link, ""
  element :xml_generation_link, ""
  element :rollbacks_link, ""

  def open_new_measure_form
    create_measures_link.click
  end

  def open_new_quota_form
    create_quotas_link.click
  end
end
