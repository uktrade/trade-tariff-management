class TariffMainMenuPage < SitePrism::Page

  set_url ENV['BASE_URL']

  # section :work_baskets, TariffWorkBasketsSection, '.workbaskets .table tbody'
  element :create_measures_link, "#main-menu div:nth-child(7) a[href$='/new']"
  element :find_edit_measures_link, "#main-menu div:nth-child(7) a[href$='/measure']"
  element :create_quotas_link, "#main-menu div:nth-child(8) a[href$='/new']"
  element :find_edit_quotas_link, "#main-menu div:nth-child(8) a[href$='/quotas']"

  def create_new_measure
    create_measures_link.click
  end

  def create_new_quota
    create_quotas_link.click
  end
end