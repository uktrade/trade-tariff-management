module CapybaraFormHelper
  def input_date(label, date)
    fill_in(label, with: date.strftime("%d/%m/%Y"))
    blur_focus
  end

  def blur_focus
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
end
