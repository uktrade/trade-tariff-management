module WorkbasketHelper
  def create_measures_section_header
    case current_step
    when "main"
      "Create measures"
    when "duties_conditions_footnotes"
      "Specify duties, conditions and footnotes"
    when "review_and_submit"
      "Review and submit"
    end
  end

  def create_quota_section_header
    case current_step
    when "main"
      "Create a quota"
    when "configure_quota"
      "Configure the quota"
    when "conditions_footnotes"
      "Specify conditions and footnotes (optional)"
    when "review_and_submit"
      "Review and submit"
    end
  end
end
