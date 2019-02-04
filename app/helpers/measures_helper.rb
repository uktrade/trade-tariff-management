module MeasuresHelper
  def safe_json(data)
    data.to_json
        .html_safe
  end

  def find_measure_condition_group_name
    [
      %w[is is],
      ["is_not", "is not"],
      ["is_not_specified", "is not specified"],
      ["is_not_unspecified", "is not unspecified"],
      ["starts_with", "starts with"]
    ]
  end

  def search_in_measures_by_regulation_rule(item)
    {
      search: {
        regulation: {
          enabled: "1",
          operator: "is",
          value: item.regulation_id
        }
      }
    }
  end
end
