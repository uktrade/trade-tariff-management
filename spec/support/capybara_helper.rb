module CapybaraHelper

  def custom_select(value, options = {})
    script = <<END_SCRIPT
var select = $( "form :contains('#{options[:from]}') select" )[0].selectize;
if (select) {
  var id = select.search('#{value}').items[0].id;
  if (id) {
    select.setValue(id, false);
  }
}
END_SCRIPT
    page.driver.execute_script(script)
  end
end
