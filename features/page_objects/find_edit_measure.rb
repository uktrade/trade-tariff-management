class FindEditMeasure < SitePrism::Page

  element :measure_sid, "input[name='search[measure_sid][value]']"
  element :search, ".button"
  element :search_result, ".records-table .table__row"

  def find_measure(sid)
    measure_sid.set sid
    search.click
  end
end

