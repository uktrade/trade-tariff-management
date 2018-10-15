//= require ./duty-expression-formatter
//= require ./measure-condition-formatter
//= require ./url-parser
//= require ./db

$(document).ready(function() {
  var form = document.querySelector(".bulk-edit-measures");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      return {
        bulkActions: BulkEditOfMeasuresSaveActions,
        columns: [
          {enabled: true, title: "Old ID", field: "measure_sid", sortable: true, type: "number", changeProp: "measure_sid" },
          {enabled: true, title: "Regulation", field: "regulation", sortable: true, type: "string", changeProp: "regulation" },
          {enabled: true, title: "Type", field: "measure_type_id", sortable: true, type: "string", changeProp: "measure_type" },
          {enabled: true, title: "Start date", field: "validity_start_date", sortable: true, type: "date", changeProp: "validity_start_date" },
          {enabled: true, title: "End date", field: "validity_end_date", sortable: true, type: "date", changeProp: "validity_end_date" },
          {enabled: true, title: "Justification Regulation", field: "justification_regulation", sortable: true, type: "string", changeProp: "justification_regulation" },
          {enabled: true, title: "Commodity code", field: "goods_nomenclature", sortable: true, type: "number", changeProp: "goods_nomenclature" },
          {enabled: true, title: "Additional code", field: "additional_code", sortable: true, type: "string", changeProp: "additional_code" },
          {enabled: true, title: "Origin", field: "geographical_area", sortable: true, type: "string", changeProp: "geographical_area" },
          {enabled: true, title: "Origin exclusions", field: "excluded_geographical_areas", sortable: true, type: "comma_string", changeProp: "excluded_geographical_areas" },
          {enabled: true, title: "Duties", field: "duties", sortable: true, type: "duties", changeProp: "duties" },
          {enabled: true, title: "Conditions", field: "conditions", sortable: true, type: "comma_string", changeProp: "conditions" },
          {enabled: true, title: "Footnotes", field: "footnotes", sortable: true, type: "comma_string", changeProp: "footnotes" },
          {enabled: true, title: "Last updated", field: "last_updated", sortable: true, type: "date", changeProp: "last_updated" },
          {enabled: true, title: "Status", field: "status", sortable: true, type: "string", changeProp: "status" }
        ],
        actions: [
          { value: 'toggle_unselected', label: 'Hide/Show unselected items' },
          { value: 'change_regulation', label: 'Change generating regulation' },
          { value: 'change_validity_period', label: 'Change validity period...' },
          { value: 'change_origin', label: 'Change origin...' },
          { value: 'change_commodity_codes', label: 'Change commodity codes...' },
          { value: 'change_additional_code', label: 'Change additional code...' },
          { value: 'change_duties', label: 'Change duties...' },
          { value: 'change_conditions', label: 'Change conditions...' },
          { value: 'change_footnotes', label: 'Change footnotes...' },
          { value: 'remove_from_group', label: 'Remove from group...' },
          { value: 'delete', label: 'Delete measures' },
        ]
      };
    },
    mounted: function() {
      var self = this;

      history.pushState(null, null, location.href);
      window.onpopstate = function () {
        history.go(1);
      };
    },
    methods: {
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
          measure_sid: measure.measure_sid,
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

        measure.original_values = {
          validity_start_date: measure.validity_start_date
        };

        measure.validity_start_date = moment(window.all_settings.start_date, "DD/MM/YYYY", true).format("DD MMM YYYY");
        measure.changes.push("validity_start_date");

        if (window.all_settings.regulation) {
          measure.original_values.regulation = measure.regulation;

          measure.regulation = window.all_settings.regulation;
          measure.changes.push("regulation");
        }

        return measure;
      }
    }
  });
});
