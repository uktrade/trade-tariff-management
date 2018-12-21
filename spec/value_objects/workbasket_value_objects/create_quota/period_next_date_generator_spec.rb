require 'rails_helper'

describe WorkbasketValueObjects::CreateQuota::PeriodNextDateGenerator do

  let(:start_date ) { DateTime.new(2019, 1,1) }

  describe '#initialize' do
    it "sets end_date for each mode type" do
      {
        'annual'    => DateTime.new(2019, 12,31),
        'bi_annual' => DateTime.new(2019, 6, 30),
        'quarterly' => DateTime.new(2019, 3, 31),
        'monthly'   => DateTime.new(2019, 1, 31)
      }.each do |period_name, expected_end_date|
        expect(described_class.new(period_name, start_date).end_date).to eq expected_end_date
      end
    end
  end

  describe '#date_range' do
    it "returns a tuple of start and end date" do
      expect(described_class.new('quarterly', start_date).date_range).to eq [start_date, DateTime.new(2019, 3, 31)]
    end
  end

  it "covers the expected dates when used multiple times" do
    periods = []
    next_start_date = start_date

    4.times do
      start_date, end_date = described_class.new('quarterly', next_start_date).date_range
      periods << [start_date, end_date]
      next_start_date = end_date + 1
    end

    expected_periods = [
      [DateTime.new(2019, 1, 1), DateTime.new(2019, 3, 31)],
      [DateTime.new(2019, 4, 1), DateTime.new(2019, 6, 30)],
      [DateTime.new(2019, 7, 1), DateTime.new(2019, 9, 30)],
      [DateTime.new(2019, 10,1), DateTime.new(2019, 12,31)]
    ]
    expect(periods).to eq expected_periods
  end

end
