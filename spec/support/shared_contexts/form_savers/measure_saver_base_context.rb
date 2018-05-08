require "rails_helper"

shared_context "measure_saver_base_context" do

  include_context "form_savers_base_context"

  let(:measure_saver) do
    ::MeasureSaver.new(user, ops)
  end

  let(:measure_errors) do
    measure_saver.errors
  end

  let(:measure) do
    measure_saver.measure
  end

  let(:base_regulation) do
    create(:base_regulation,
      base_regulation_role: "1",
      base_regulation_id: "D9402622",
      validity_start_date: 1.year.ago,
      replacement_indicator: 0
    )
  end

  let(:measure_type_series) do
    add_measure_type_series({
      measure_type_series_id: "A",
      validity_start_date: 1.year.ago},
      "Importation and/or exportation prohibited"
    )
  end

  let(:measure_type) do
    add_measure_type({
      measure_type_id: "277",
      measure_type_series_id: measure_type_series.measure_type_series_id,
      validity_start_date: 1.year.ago,
      measure_type_acronym: "TI1"},
      "Import prohibition"
    )
  end

  let(:commodity_code) { "2833400000" }

  let(:commodity) do
    com = create(:commodity,
                 goods_nomenclature_item_id: commodity_code,
                 producline_suffix: "80",
                 validity_start_date: Date.today,
                 operation_date: Date.today)

    period = add_commodity_period(com.goods_nomenclature_sid, commodity_code)
    add_commodity_description(period,
      com.goods_nomenclature_sid,
      commodity_code,
      "Peroxosulphates (persulphates)"
    )

    com
  end

  let(:additional_code_type) do
    add_additional_code_type({
      additional_code_type_id: "3",
      validity_start_date: 1.year.ago},
      measure_type,
      "Prohibition/Restriction/Surveillance"
    )
  end

  let(:additional_code) do
    add_additional_code({
      additional_code: "060",
      additional_code_type_id: additional_code_type.additional_code_type_id,
      validity_start_date: 1.year.ago},
      "Alloy tool steel: if of tool steel as defined in Additional Note 1 (e) and (f) to Chapter 72 of the HTS (see Additional Notes (Taric) to Chapter 72): LQEX."
    )
  end

  let(:geographical_area) do
    create(:geographical_area,
      geographical_area_id: "1011",
      validity_start_date: 1.year.ago
    )
  end

  let(:duty_expression_01) do
    de = create(:duty_expression,
      duty_expression_id: "01",
      duty_amount_applicability_code: 1,
      measurement_unit_applicability_code: 0,
      monetary_unit_applicability_code: 0
    )

    create(:duty_expression_description,
      duty_expression_id: de.duty_expression_id,
      description: "% or amount"
    )

    de
  end

  let(:duty_expression_04) do
    de = create(:duty_expression,
      duty_expression_id: "04",
      duty_amount_applicability_code: 1,
      measurement_unit_applicability_code: 0,
      monetary_unit_applicability_code: 0
    )

    create(:duty_expression_description,
      duty_expression_id: de.duty_expression_id,
      description: "+ % or amount"
    )

    de
  end

  let(:monetary_unit) do
    mu = create(:monetary_unit,
      monetary_unit_code: "EUR"
    )

    create(:monetary_unit_description,
      monetary_unit_code: mu.monetary_unit_code,
      description: "EURO"
    )

    mu
  end

  let(:measurement_unit) do
    mu = create(:measurement_unit,
      measurement_unit_code: "DTN"
    )

    create(:measurement_unit_description,
      measurement_unit_code: mu.measurement_unit_code,
      description: "Hectokilogram"
    )

    mu
  end

  let(:measurement_unit_qualifier) do
    muq = create(:measurement_unit_qualifier,
      measurement_unit_qualifier_code: "X"
    )

    create(:measurement_unit_qualifier_description,
      measurement_unit_qualifier_code: muq.measurement_unit_qualifier_code,
      description: "Hectolitre"
    )

    muq
  end

  let(:base_ops) do
    {
      operation_date: date_to_s(operation_date),
      start_date: date_to_s(validity_start_date),
      end_date: date_to_s(validity_end_date),
      regulation_id: base_regulation.base_regulation_id,
      measure_type_series_id: measure_type_series.measure_type_series_id,
      measure_type_id: measure_type.measure_type_id,
      goods_nomenclature_code: commodity_code,
      additional_code: additional_code.additional_code,
      additional_code_type_id: additional_code_type.additional_code_type_id,
      geographical_area_id: geographical_area.geographical_area_id,
      excluded_geographical_areas: []
    }
  end

  def add_measure_type_series(ops={}, description)
    mts = create(:measure_type_series, ops)

    create(
      :measure_type_series_description,
      measure_type_series_id: mts.measure_type_series_id,
      description: description
    )

    mts
  end

  def add_measure_type(ops={}, description)
    mt = create(:measure_type, ops)
    create(
      :measure_type_description,
      measure_type_id: mt.measure_type_id,
      description: description
    )

    mt
  end

  def add_commodity_period(sid, code)
    create(:goods_nomenclature_description_period,
      goods_nomenclature_sid: sid,
      goods_nomenclature_item_id: code,
      productline_suffix: "80",
      validity_start_date: Date.today
    )
  end

  def add_commodity_description(period, sid, code, description)
    create(:goods_nomenclature_description,
      goods_nomenclature_description_period_sid: period.goods_nomenclature_description_period_sid,
      language_id: "EN",
      goods_nomenclature_sid: sid,
      goods_nomenclature_item_id: code,
      productline_suffix: "80",
      description: description
    )
  end

  def add_additional_code_type(ops={}, measure_type, description)
    ac_type = create(:additional_code_type, ops)
    add_additional_code_type_description(ac_type, description)
    add_additional_code_type_measure_type(ac_type, measure_type)

    ac_type
  end

  def add_additional_code_type_description(additional_code_type, description)
    create(:additional_code_type_description,
      additional_code_type_id: additional_code_type.additional_code_type_id,
      description: description
    )
  end

  def add_additional_code_type_measure_type(additional_code_type, measure_type)
    create(:additional_code_type_measure_type,
      additional_code_type_id: additional_code_type.additional_code_type_id,
      measure_type_id: measure_type.measure_type_id,
      validity_start_date: additional_code_type.validity_start_date
    )
  end

  def add_additional_code(ops={}, description)
    ft = create(:additional_code, ops)
    add_additional_code_description(ft, description)

    ft
  end

  def add_additional_code_description(additional_code, description)
    base_ops = {
      additional_code_sid: additional_code.additional_code_sid,
      additional_code: additional_code.additional_code,
      additional_code_type_id: additional_code.additional_code_type_id
    }

    period = create(:additional_code_description_period,
      base_ops.merge(validity_start_date: additional_code.validity_start_date)
    )

    create(:additional_code_description,
      base_ops.merge(
        description: description,
        additional_code_description_period_sid: period.additional_code_description_period_sid
      )
    )
  end
end
