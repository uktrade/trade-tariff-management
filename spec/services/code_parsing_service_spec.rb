require 'rails_helper'

describe CodeParsingService do
  describe '#csv_string_to_array' do
    it "returns an empty array for an empty string" do
      expect(described_class.csv_string_to_array("")).to eq([])
    end

    it "returns an empty array for nil input" do
      expect(described_class.csv_string_to_array(nil)).to eq([])
    end

    it "parses multiple comma separated values to an array" do
      expect(described_class.csv_string_to_array("0101300000, 0101900000")). to eq(["0101300000", "0101900000"])
    end
  end
end
