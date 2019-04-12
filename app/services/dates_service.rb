class DatesService
  def self.overlap?(dates)
    overlap = []
    dates.each do |period|
      dates.map do |other_period|
        next if period == other_period
        overlap << (other_period[:start_date].to_date).between?(period[:start_date].to_date, period[:end_date].to_date)
      end
    end
    overlap.include?(true)
  end
end
