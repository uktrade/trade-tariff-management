//= require ./duty-expression-formatter
//= require ./measure-condition-formatter

$(document).ready(function() {
  var form = document.querySelector(".bulk-edit-measures");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      return {
        selectedMeasures: [],
        showTooltips: true,
        columns: [
          {enabled: true, title: "ID", field: "measure_sid", sortable: true, type: "number" },
          {enabled: true, title: "Regulation", field: "regulation", sortable: true, type: "string" },
          {enabled: true, title: "Type", field: "measure_type_id", sortable: true, type: "string" },
          {enabled: true, title: "Valid from", field: "validity_start_date", sortable: true, type: "date" },
          {enabled: true, title: "Valid to", field: "validity_end_date", sortable: true, type: "date" },
          {enabled: true, title: "Commodity code", field: "goods_nomenclature", sortable: true, type: "string" },
          {enabled: true, title: "Additional code", field: "additional_code", sortable: true, type: "string" },
          {enabled: true, title: "Origin", field: "geographical_area", sortable: false },
          {enabled: true, title: "Origin exclusions", field: "excluded_geographical_areas", sortable: false },
          {enabled: true, title: "Duties", field: "duties", sortable: false },
          {enabled: true, title: "Conditions", field: "conditions", sortable: false },
          {enabled: true, title: "Footnotes", field: "footnotes", sortable: false },
          {enabled: true, title: "Last updated", field: "last_updated", sortable: true, type: "date" },
          {enabled: true, title: "Status", field: "status", sortable: true, type: "string" }
        ],
        actions: [
          { value: 'toggle_unselected', label: 'Hide/Show unselected items' },
          { value: 'make_copies', label: 'Make copies...' },
          { value: 'change_regulation', label: 'Change generating regulation' },
          { value: 'change_validity_period', label: 'Change validity period...' },
          { value: 'change_origin', label: 'Change origin...' },
          { value: 'change_community_code', label: 'Change community code...' },
          { value: 'change_additional_code', label: 'Change additional code...' },
          { value: 'change_quota', label: 'Change quota...' },
          { value: 'change_duties', label: 'Change duties...' },
          { value: 'change_conditions', label: 'Change conditions...' },
          { value: 'change_footnotes', label: 'Change footnotes...' },
          { value: 'change_status', label: 'Change status...' },
          { value: 'delete', label: 'Delete...' },
        ],
        measures: [],
        changingDuties: false,
        changingConditions: false,
        deleting: false,
        changingFootnotes: false,
        changingAdditionalCode: false,
        changingCommunityCode: false,
        changingOrigin: false,
        makingCopies: false,
        changingRegulation: false,
        changingValidityPeriod: false,
        changingQuota: false,
        changingStatus: false,
        isLoading: true,
        pagination: {
          total_count: window.__pagination_metadata.total_count,
          page: window.__pagination_metadata.page,
          per_page: window.__pagination_metadata.per_page,
          pages: Math.ceil(window.__pagination_metadata.total_count / window.__pagination_metadata.per_page)
        }
      };
    },
    mounted: function() {
      var self = this;

      this.loadMeasures(1, this.loadNextPage.bind(this));
    },
    computed: {
      noSelectedMeasures: function() {
        return this.selectedMeasures.length === 0;
      },
      visibleMeasures: function() {
        return this.measuresForTable.filter(function (measure) {
          return measure.visible;
        });
      },
      selectedMeasureObjects: function() {
        var selectedSids = this.selectedMeasures;

        return this.measures.filter(function(measure) {
          return selectedSids.indexOf(measure.measure_sid) > -1;
        });
      },
      measuresForTable: function() {
        return this.measures.map(function(measure) {
          var formatted_exclusions = measure.excluded_geographical_areas.map(function (ega) {
            if (ega.is_country) {
              return ega.geographical_area_id;
            }

            return ega.description;
          }).join("<br />") || "-";

          var formatted_components = measure.measure_components.map(function (mc) {
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
            regulation: measure.regulation.base_regulation_id,
            measure_type_id: measure.measure_type.measure_type_id,
            goods_nomenclature: measure.goods_nomenclature.goods_nomenclature_item_id,
            additional_code: "-",
            geographical_area: origin,
            excluded_geographical_areas: formatted_exclusions,
            duties: formatted_components,
            conditions: formatted_conditions,
            footnotes: formatted_footnotes,
            last_updated: measure.operation_date,
            status: measure.status,
            visible: measure.visible,
            validity_start_date: measure.validity_start_date,
            validity_end_date: measure.validity_end_date
          }
        });
      }
    },
    methods: {
      addOriginExclusion: function() {
        this.origin_exclusions.push({ value: '' });
      },
      onItemSelected: function(sid) {
        this.selectedMeasures.push(sid);
      },
      onItemDeselected: function(sid) {
        var index = this.selectedMeasures.indexOf(sid);

        if (index === -1) {
          return;
        }

        this.selectedMeasures.splice(index, 1);
      },
      toggleUnselected: function() {
        var selected = this.selectedMeasures;

        this.measures.forEach(function(measure) {
          if (selected.indexOf(measure.measure_sid) === -1) {
            measure.visible = !measure.visible;
          }
        });
      },

      triggerAction: function(val) {

        switch(val) {
          case 'toggle_unselected':
            this.toggleUnselected();
            break;
          case 'make_copies':
            this.makingCopies = true;
            break;
          case 'change_regulation':
            this.changingRegulation = true;
            break;
          case 'change_validity_period':
            this.changingValidityPeriod = true;
            break;
          case 'change_origin':
            this.changingOrigin = true;
            break;
          case 'change_community_code':
            this.changingCommunityCode = true;
            break;
          case 'change_additional_code':
            this.changingAdditionalCode = true;
            break;
          case 'change_quota':
            this.changingQuota = true;
            break;
          case 'change_duties':
            this.changingDuties = true;
            break;
          case 'change_conditions':
            this.changingConditions = true;
            break;
          case 'change_footnotes':
            this.changingFootnotes = true;
            break;
          case 'change_status':
            this.changingStatus = true;
            break;
          case 'delete':
            this.deleting = true;
            break;
        }
      },
      closeAllPopups: function() {
        this.changingDuties = false;
        this.changingConditions = false;
        this.deleting = false;
        this.changingFootnotes = false;
        this.changingAdditionalCodes= false;
        this.changingCommunityCode = false;
        this.changingOrigin = false;
        this.makingCopies = false;
        this.changingRegulation = false;
        this.changingValidityPeriod = false;
        this.changingQuota = false;
        this.changingStatus = false;
      },
      loadMeasures: function(page, callback) {
        var self = this;

        $.get(window.location.href, function(data) {
          self.measures = self.measures.concat(data.measures.map(function(measure) {
            measure.visible = true;

            return measure;
          }));

          self.pagination.page = parseInt(data.current_page, 10);
          self.pagination.pages = parseInt(data.total_pages, 10);

          callback();
        });
      },
      loadNextPage: function() {
        if (this.pagination.page === this.pagination.pages) {
          this.isLoading = false;
          return;
        }

        this.loadMeasures(this.pagination.page + 1, this.loadNextPage.bind(this));
      }
    }
  });
});
