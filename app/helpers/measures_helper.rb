module MeasuresHelper
  def safe_json(data)
    data.to_json
        .html_safe
  end
end
