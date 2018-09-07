module CapybaraHelper

  def custom_select(page, name, value)
    script = <<END_SRIPT
var select = $( "form :contains('#{name}') select" )[0].selectize;
if (select) {
  var id = select.search('#{value}').items[0].id;
  if (id) {
    select.setValue(id, false);
  }
}
END_SRIPT
    page.driver.execute_script(script)
  end

end
