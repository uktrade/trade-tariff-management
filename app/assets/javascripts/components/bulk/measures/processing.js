//= require ../../duty-expression-formatter
//= require ../../measure-condition-formatter

window.BulkEditing.Measures.Processing = {
  recordTableProcessing: function(measure) {
    var formatted_exclusions = measure.excluded_geographical_areas.map(function (ega) {
      return ega.geographical_area_id;
    }).join(", ") || "-";

    var formatted_components = measure.measure_components.filter(function(mc) {
      return mc.duty_expression && mc.duty_expression.duty_expression_id;
    }).map(function (mc) {
      return DutyExpressionFormatter.format({
        duty_expression_id: mc.duty_expression.duty_expression_id,
        duty_expression_description: mc.duty_expression.description,
        duty_expression_abbreviation: mc.duty_expression.abbreviation,
        duty_amount: mc.duty_amount,
        monetary_unit: mc.monetary_unit,
        monetary_unit_abbreviation: mc.monetary_unit ? mc.monetary_unit.abbreviation : null,
        measurement_unit: mc.measurement_unit,
        measurement_unit_qualifier: mc.measurement_unit_qualifier
      });
    }).join(" ");

    var formatted_conditions = measure.measure_conditions.map(function(mc) {
      return MeasureConditionFormatter.format(mc);
    }).join(", ") || "-";

    var formatted_footnotes = measure.footnotes.map(function (ft) {
      return ft.footnote_type_id + " - " + ft.footnote_id;
    }).join(", ") || "-";

    var origin = "-";

    if (measure.geographical_area) {
      if (measure.geographical_area.is_country) {
        origin = measure.geographical_area.geographical_area_id;
      } else {
        origin = measure.geographical_area.description;
      }
    }

    return {
      clone: measure.clone,
      row_id: measure.row_id,
      measure_sid: measure.measure_sid,
      errors: measure.errors,
      sid: measure.clone ? "&nbsp;" : measure.measure_sid,
      regulation: measure.regulation.formatted_id,
      justification_regulation: measure.justification_regulation ? measure.justification_regulation.formatted_id : "-",
      measure_type_id: measure.measure_type.measure_type_id,
      goods_nomenclature: measure.goods_nomenclature ? measure.goods_nomenclature.goods_nomenclature_item_id : "-",
      additional_code: measure.additional_code || "-",
      geographical_area: origin,
      excluded_geographical_areas: formatted_exclusions,
      duties: formatted_components,
      conditions: formatted_conditions,
      footnotes: formatted_footnotes,
      last_updated: measure.operation_date,
      status: measure.status,
      visible: measure.visible,
      deleted: measure.deleted,
      validity_start_date: measure.validity_start_date,
      validity_end_date: measure.validity_end_date || "&ndash;",
      changes: measure.changes
    }
  },

  preprocessRecord: function(measure) {
    var noChanges = true;

    if (measure.changes && measure.changes.length > 0) {
      return measure;
    }

    measure.measure_sid += '';

    measure.row_id = makeBigNumber();

    measure.original_values = {
      validity_start_date: measure.validity_start_date
    };

    measure.validity_start_date = moment(window.all_settings.start_date, ["DD/MM/YYYY", "DD MMM YYYY", "YYYY-MM-DD"], true).format("DD MMM YYYY");
    measure.changes.push("validity_start_date");

    if (window.all_settings.regulation) {
      measure.original_values.regulation = measure.regulation;

      measure.regulation = window.all_settings.regulation;
      measure.changes.push("regulation");
    }

    return measure;
  }
};
