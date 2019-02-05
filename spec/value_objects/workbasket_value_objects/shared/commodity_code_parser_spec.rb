require 'rails_helper'

describe WorkbasketValueObjects::Shared::CommodityCodeParser do

  before(:each) do
    [
      # from production db dump
      ['0101000000', '80', '1972-01-01 00:00:00.000000', nil],                          # not a leaf so will never be returned
      ['0101110000', '10', '1972-01-01 00:00:00.000000', '2001-12-31 00:00:00.000000'], # producline_suffix not 80 so never returned
      ['0101110000', '80', '1972-01-01 00:00:00.000000', '2001-12-31 00:00:00.000000'], # will be returned if within dates
      ['0101190000', '80', '1972-01-01 00:00:00.000000', '2001-12-31 00:00:00.000000'], # not a leaf so will never be returned
      ['0101191000', '80', '1972-01-01 00:00:00.000000', '2001-12-31 00:00:00.000000'], # will be returned if within dates
      ['0101199000', '80', '1972-01-01 00:00:00.000000', '2001-12-31 00:00:00.000000'], # will be returned if within dates
      ['0101200000', '80', '1972-01-01 00:00:00.000000', '2001-12-31 00:00:00.000000'], # not a leaf so will never be returned
      ['0101201000', '80', '1972-01-01 00:00:00.000000', '2001-12-31 00:00:00.000000'], # will be returned if within dates
      ['0101209000', '80', '1972-01-01 00:00:00.000000', '2001-12-31 00:00:00.000000'], # will be returned if within dates
      ['0101100000', '80', '2002-01-01 00:00:00.000000', '2011-12-31 00:00:00.000000'], # not a leaf so will never be returned
      ['0101101000', '80', '2002-01-01 00:00:00.000000', '2011-12-31 00:00:00.000000'], # will be returned if within dates
      ['0101109000', '80', '2002-01-01 00:00:00.000000', '2011-12-31 00:00:00.000000'], # will be returned if between 30/06/2011 and 31/12/2011
      ['0101900000', '80', '2002-01-01 00:00:00.000000', nil],                          # not a leaf so will never be returned
      ['0101901100', '10', '2002-01-01 00:00:00.000000', '2011-12-31 00:00:00.000000'], # producline_suffix not 80 so never returned
      ['0101901100', '80', '2002-01-01 00:00:00.000000', '2011-12-31 00:00:00.000000'], # will be returned if within dates
      ['0101901900', '80', '2002-01-01 00:00:00.000000', '2011-12-31 00:00:00.000000'], # will be returned if within dates
      ['0101903000', '80', '2002-01-01 00:00:00.000000', '2011-12-31 00:00:00.000000'], # will be returned if within dates
      ['0101909000', '80', '2002-01-01 00:00:00.000000', '2011-12-31 00:00:00.000000'], # will be returned if within dates
      ['0101109010', '80', '2002-01-01 00:00:00.000000', '2011-06-30 00:00:00.000000'], # will be returned if within dates
      ['0101109090', '80', '2002-01-01 00:00:00.000000', '2011-06-30 00:00:00.000000'], # will be returned if within dates
      ['0101210000', '80', '2012-01-01 00:00:00.000000', nil],                          # will be returned if within dates
      ['0101210000', '10', '2012-01-01 00:00:00.000000', nil],                          # producline_suffix not 80 so never returned
      ['0101290000', '80', '2012-01-01 00:00:00.000000', nil],                          # not a leaf so will never be returned
      ['0101291000', '80', '2012-01-01 00:00:00.000000', nil],                          # will be returned if within dates
      ['0101299000', '80', '2012-01-01 00:00:00.000000', nil],                          # will be returned if within dates
      ['0101300000', '80', '2012-01-01 00:00:00.000000', nil],                          # will be returned if within dates
      # the following are made up
      ['0102000000', '80', '1972-01-01 00:00:00.000000', nil],                          # not a leaf so will never be returned
      ['0200000000', '80', '2012-01-01 00:00:00.000000', nil],                          # will be returned if within dates
      ['0101000000', '80', '2020-01-01 00:00:00.000000', nil],                          # not yet active so never returned
    ].each do |comm_code|
      create :goods_nomenclature, goods_nomenclature_item_id: comm_code[0], producline_suffix: comm_code[1], validity_start_date: comm_code[2], validity_end_date: comm_code[3]
    end
  end

  describe 'regression checks' do
    it "retrieves all leaves in the tree from a given code" do
      #check old codes
      expect(described_class.get_child_code_leaves(query_date: "01/01/2009".to_date, code: "0101109090")).to eq(["0101109090"])
      expect(described_class.get_child_code_leaves(query_date: "01/01/2009".to_date, code: "0101109000")).to eq(["0101109010", "0101109090"])
      expect(described_class.get_child_code_leaves(query_date: "01/01/2009".to_date, code: "0101100000")).to eq(["0101101000", "0101109010", "0101109090"])

      expect(described_class.get_child_code_leaves(query_date: "01/01/2000".to_date, code: "0101100000")).to eq(["0101110000", "0101191000", "0101199000"])
    end

    it "doesn't match expired codes when searching current date" do
      expect(described_class.get_child_code_leaves(query_date: "01/01/2019".to_date, code: "0101100000")).to eq([])

    end

    it "matches open ended codes" do
      #check newer codes without end date
      expect(described_class.get_child_code_leaves(query_date: "01/01/2019".to_date, code: "0101290000")).to eq(["0101291000", "0101299000"])
      expect(described_class.get_child_code_leaves(query_date: "01/01/2019".to_date, code: "0101000000")).to eq(["0101210000", "0101291000", "0101299000", "0101300000", "0101900000"])
      expect(described_class.get_child_code_leaves(query_date: "01/01/2019".to_date, code: "0100000000")).to eq(["0101210000", "0101291000", "0101299000", "0101300000", "0101900000", "0102000000"])

      expect(described_class.get_child_code_leaves(query_date: "01/01/2019".to_date, code: "0200000000")).to eq(["0200000000"])

    end

    it "returns different values when a sub-code has expired" do
      #check 0101109000 is a leaf on some dates
      expect(described_class.get_child_code_leaves(query_date: "01/05/2011".to_date, code: "0101100000")).to eq(["0101101000", "0101109010", "0101109090"])
      expect(described_class.get_child_code_leaves(query_date: "01/12/2011".to_date, code: "0101100000")).to eq(["0101101000", "0101109000"])
    end
  end
end
