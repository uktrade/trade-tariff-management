require "rails_helper"

RSpec.describe XmlGeneration::TransactionGrouper do
  it "groups records by record code" do
    measure = instance_double(Measure, record_code: "420", subrecord_code: "10")
    measure_2 = instance_double(Measure, record_code: "420", subrecord_code: "10")
    footnote = instance_double(Footnote, record_code: "200", subrecord_code: "20")

    groups = subject.group([measure, footnote, measure_2])

    expect(groups.count).to eq 2

    record_codes_per_group = groups.map do |group|
      group.map(&:record_code)
    end

    expect(record_codes_per_group).to contain_exactly ["420", "420"], ["200"]
  end

  it "orders groups by record code" do
    measure = instance_double(Measure, record_code: "420", subrecord_code: "10")
    measure_2 = instance_double(Measure, record_code: "420", subrecord_code: "10")
    footnote = instance_double(Footnote, record_code: "200", subrecord_code: "20")

    groups = subject.group([measure, footnote, measure_2])

    expect(groups.first.map(&:record_code)).to eq ["200"]
    expect(groups.last.map(&:record_code)).to eq ["420", "420"]
  end

  describe "within each group" do
    it "orders by subrecord code" do
      first = instance_double(Footnote, record_code: "200", subrecord_code: "10")
      mid = instance_double(FootnoteType, record_code: "200", subrecord_code: "50")
      last = instance_double(FootnoteDescription, record_code: "200", subrecord_code: "90")

      group = subject.group([last, first, mid]).first

      expect(group.map(&:subrecord_code)).to eq ["10", "50", "90"]
    end
  end
end
