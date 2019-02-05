class CodeParsingService
  def self.csv_string_to_array(codes_string)
    codes_string = codes_string || ""
    codes_string.split(/[\s|,]+/)
      .map(&:strip)
      .reject(&:blank?)
      .uniq
      .sort
  end
end
