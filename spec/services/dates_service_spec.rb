require 'rails_helper'

describe DatesService do
  describe '#overlap?' do
    let(:overlapping_dates) do
      [
        {
          start_date: Date.new(2019, 1, 1),
          end_date: Date.new(2019, 1, 31)
        },
        {
          start_date: Date.new(2019, 1, 31),
          end_date: Date.new(2019, 2, 20)
        },
        {
          start_date: Date.new(2019, 2, 21),
          end_date: Date.new(2019, 2, 24)
        }
      ]
    end
    let(:valid_dates) do
      [
        {
          start_date: Date.new(2019, 1, 1),
          end_date: Date.new(2019, 1, 31)
        },
        {
          start_date: Date.new(2019, 2, 1),
          end_date: Date.new(2019, 2, 20)
        },
        {
          start_date: Date.new(2019, 2, 20),
          end_date: Date.new(2019, 2, 21)
        }
      ]
    end
    it 'returns true if there is some overlap of dates' do
      expect(DatesService.overlap?(overlapping_dates)).to eq true
    end

    it 'returns false if there is no overlap of dates' do
      expect(DatesService.overlap?(valid_dates)).to eq false
    end
  end
end
