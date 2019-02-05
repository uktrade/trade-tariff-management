require 'rails_helper'

describe WorkbasketValueObjects::Shared::CommodityCodesAnalyzer do

  context 'with saved nomenclature' do
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
      it "retrieves the correct code for given code with no exclusion" do
        analyser = described_class.new(start_date: "01/01/2019".to_date, commodity_codes: "0101110000", commodity_codes_exclusions: nil)
        expect(analyser.commodity_codes_formatted).to eq("0101110000")
        expect(analyser.exclusions_formatted).to eq("")
        expect(analyser.commodity_codes).to eq("0101110000")
        expect(analyser.commodity_codes_exclusions).to eq(nil)
        expect(analyser.collection).to eq(["0101110000"])
      end

      it "retrieves the correct codes for given code with an exclusion" do
        analyser = described_class.new(start_date: "01/01/2019".to_date, commodity_codes: "0101000000", commodity_codes_exclusions: ["0101210000"])
        expect(analyser.commodity_codes_formatted).to eq("0101291000, 0101299000, 0101300000, 0101900000")
        expect(analyser.exclusions_formatted).to eq("0101210000")
        expect(analyser.commodity_codes).to eq("0101000000")
        expect(analyser.commodity_codes_exclusions).to eq(["0101210000"])
        expect(analyser.collection).to eq(["0101291000", "0101299000", "0101300000", "0101900000"])
      end

      it "retrieves the correct codes for multiple codes with no exclusion" do
        analyser = described_class.new(start_date: "01/01/2019".to_date, commodity_codes: "0101210000, 0101290000", commodity_codes_exclusions: nil)
        expect(analyser.commodity_codes_formatted).to eq("0101210000, 0101290000")
        expect(analyser.exclusions_formatted).to eq("")
        expect(analyser.commodity_codes).to eq("0101210000, 0101290000")
        expect(analyser.commodity_codes_exclusions).to eq(nil)
        expect(analyser.collection).to eq(["0101210000", "0101290000"])
      end

      it "retrieves the correct codes for multiple codes with an exclusion in one" do
        analyser = described_class.new(start_date: "01/01/2019".to_date, commodity_codes: "0101200000, 0101300000", commodity_codes_exclusions: ["0101291000"])
        expect(analyser.commodity_codes_formatted).to eq("0101210000, 0101299000, 0101300000")
        expect(analyser.exclusions_formatted).to eq("0101291000")
        expect(analyser.commodity_codes).to eq("0101200000, 0101300000")
        expect(analyser.commodity_codes_exclusions).to eq(["0101291000"])
        expect(analyser.collection).to eq(["0101210000", "0101299000", "0101300000"])
      end
    end
  end
end
