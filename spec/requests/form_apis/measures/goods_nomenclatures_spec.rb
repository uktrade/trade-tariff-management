require 'rails_helper'

describe "Measure Form APIs: Goods nomenclatures", type: :request do

  include_context "form_apis_base_context"

  let!(:section) do
    create(:section,
      position: 6,
      numeral: "VI",
      title: "Products of the chemical or allied industries"
    )
  end

  let(:chapter_code) { "2800000000" }

  let!(:chapter) do
    ch = create(:chapter,
      goods_nomenclature_item_id: chapter_code,
      producline_suffix: "80",
      validity_start_date: Date.today
    )

    period = add_period(ch.goods_nomenclature_sid, chapter_code)
    add_description(period,
      ch.goods_nomenclature_sid,
      chapter_code,
      "Inorganic chemicals; organic or inorganic compounds of precious metals, of rare-earth metals, of radioactive elements or of isotopes"
    )

    create(:chapter_section,
      goods_nomenclature_sid: ch.goods_nomenclature_sid,
      section_id: section.id
    )

    ch
  end

  let(:heading_code) { "2833000000" }

  let!(:heading) do
    hd = create(:heading,
      goods_nomenclature_item_id: heading_code,
      producline_suffix: "80",
      validity_start_date: Date.today
    )

    period = add_period(hd.goods_nomenclature_sid, heading_code)
    add_description(period,
      hd.goods_nomenclature_sid,
      heading_code,
      "Sulphates; alums; peroxosulphates (persulphates)"
    )

    hd
  end

  let(:commodity_code) { "2833400000" }

  let!(:commodity) do
    com = create(:commodity,
                 goods_nomenclature_item_id: commodity_code,
                 producline_suffix: "80",
                 validity_start_date: Date.today,
                 operation_date: Date.today)

    period = add_period(com.goods_nomenclature_sid, commodity_code)
    add_description(period,
      com.goods_nomenclature_sid,
      commodity_code,
      "Peroxosulphates (persulphates)"
    )

    com
  end

  let(:expecting_html) do
    <<-eos
<div class="tariff-breadcrumbs js-tariff-breadcrumbs clt font-xsmall">
  <nav>
    <ul>
      <li>
        Section VI: Products of the chemical or allied industries
        <ul>
          <li class="chapter-li">
            <div class="chapter-code">
              <div class="code-text">28</div>
            </div>
            Inorganic chemicals; organic or inorganic compounds of precious metals, of rare-earth metals, of radioactive elements or of isotopes
            <ul>
              <li class="heading-li">
                <div class="heading-code">
                  <div class="code-text">33</div>
                </div>
                Sulphates; alums; peroxosulphates (persulphates)
                <ul class="commodities">
                  <li>
                    <li class="commodity-li">
                      <h1>Peroxosulphates (persulphates)</h1>
                    </li>
                  </li>
                </ul>
              </li>
            </ul>
          </li>
        </ul>
      </li>
    </ul>
  </nav>
</div>
    eos
  end

  context "Index" do
    before do
    end

    it "should return JSON collection of all actual goods_nomenclatures" do
      get "/goods_nomenclatures.html", params: { q: commodity_code }, headers: headers

      expect(
        remove_special_chars(response.body)
      ).to be_eql(
        remove_special_chars(expecting_html)
      )
    end
  end

  private

    def add_period(sid, code)
      create(:goods_nomenclature_description_period,
        goods_nomenclature_sid: sid,
        goods_nomenclature_item_id: code,
        productline_suffix: "80",
        validity_start_date: Date.today
      )
    end

    def add_description(period, sid, code, description)
      create(:goods_nomenclature_description,
        goods_nomenclature_description_period_sid: period.goods_nomenclature_description_period_sid,
        language_id: "EN",
        goods_nomenclature_sid: sid,
        goods_nomenclature_item_id: code,
        productline_suffix: "80",
        description: description
      )
    end

    def remove_special_chars(html)
      html.gsub(/[^a-zA-Z0-9\-]/,"")
    end
end

