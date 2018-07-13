module MeasuresHelper
  def safe_json(data)
    data.to_json
        .html_safe
  end

  def find_measure_condition_group_name
    [
      [ "is", "is" ],
      [ "is_not", "is not" ],
      [ "is_not_specified", "is not specified" ],
      [ "is_not_unspecified", "is not unspecified" ],
      [ "starts_with", "starts with" ]
    ]
  end

  def create_measures_header
    case params[:step]
    when "main"
      "Create measures"
    when "duties_conditions_footnotes"
      "Specify duties, conditions and footnotes"
    when "review_and_submit"
      "Review and submit"
    end
  end

  def create_meaasures_previous_step
    case params[:step]
    when "duties_conditions_footnotes"
      "main"
    when "review_and_submit"
      "duties_conditions_footnotes"
    end
  end
end
