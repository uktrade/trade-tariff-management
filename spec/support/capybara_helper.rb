module CapybaraHelper

  def custom_select(value, options = {})
    script = <<END_SRIPT
var select = $( "form :contains('#{options[:from]}') select" )[0].selectize;
if (select) {
  var id = select.search('#{value}').items[0].id;
  if (id) {
    select.setValue(id, false);
  }
}
END_SRIPT
    page.driver.execute_script(script)
  end

  def fill_date(name, options = {})
    element = find(:css, "$( \"label:contains('#{name}') ~ input\" )[0]")
    element.set(options[:with])
  end

end
