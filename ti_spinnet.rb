class Ti
  class << self
    def run(measure_sid)
      Sequel::Model.db.transaction(rollback: :always) do
        measure = Measure.new

        measure.measure_sid = measure_sid
        measure.measure_type_id = "420"

        measure.geographical_area_sid = 400
        measure.geographical_area_id = "1011"

        measure.goods_nomenclature_item_id = "3802900011"
        measure.goods_nomenclature_sid = 96982

        measure.validity_start_date = 1.months.from_now
        measure.validity_end_date = 2.months.from_now

        measure.measure_generating_regulation_role = 4
        measure.measure_generating_regulation_id = "C1602001"

        measure.reduction_indicator = 1

        measure.stopped_flag = false
        measure.national = true
        measure.save

        puts ""
        puts "[PERSISTED MEASURE] #{measure.measure_sid} | #{measure.oid}"
        puts ""

        measure_component = MeasureComponent.new

        measure_component.duty_expression_id = "01"
        measure_component.duty_amount = 11.0

        measure_component.measurement_unit_code = "ASV"
        measure_component.measurement_unit_qualifier_code = "D"
        measure_component.monetary_unit_code = "EUR"

        measure_component.national = true
        measure_component.measure_sid = measure.measure_sid
        measure_component.measure = measure
        measure_component.save

        puts ""
        puts "[PERSISTED MEASURE COMPONENT] #{measure_component.oid}"
        puts ""

        sleep 30

        puts ""
        puts "[FINAL PAUSE SECS]"
        puts ""

        sleep 5
      end
    end
  end
end
