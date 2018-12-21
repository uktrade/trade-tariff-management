require 'rails_helper'

describe WorkbasketValueObjects::CreateQuota::PeriodGenerator do

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

  describe '#current_period' do
    it "returns a tuple of start and end date" do
      expect(described_class.new('quarterly', start_date).current_period).to eq [start_date, DateTime.new(2019, 3, 31)]
      expect(described_class.new('bi_annual', start_date).current_period).to eq [start_date, DateTime.new(2019, 6, 30)]
    end
  end

  describe "#increment_period!" do

    it "covers the expected dates when called multiple times" do
      monthly_periods = described_class.new('monthly', start_date)
      expect(monthly_periods.increment_period!).to eq [DateTime.new(2019, 2, 1), DateTime.new(2019, 2, 28)]
      expect(monthly_periods.increment_period!).to eq [DateTime.new(2019, 3, 1), DateTime.new(2019, 3, 31)]


      annual_periods = described_class.new('annual', start_date)
      expect(annual_periods.increment_period!).to eq [DateTime.new(2020, 1, 1), DateTime.new(2020, 12, 31)]
      expect(annual_periods.increment_period!).to eq [DateTime.new(2021, 1, 1), DateTime.new(2021, 12, 31)]
    end
  end

end
