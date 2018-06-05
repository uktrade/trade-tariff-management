//= require ./duty-expressions-parser

$(document).ready(function() {
  var form = document.querySelector(".find-measures");

  if (!form) {
    return;
  }

  var conditions = {
    is: { value: "is", label: "is" },
    is_not: { value: "is_not", label: "is not" },
    starts_with: { value: "starts_with", label: "starts with" },
    contains: { value: "contains", label: "contains" },
    does_not_contain: { value: "does_not_contain", label: "does not contain" },
    is_after: { value: "is_after", label: "is after" },
    is_before: { value: "is_before", label: "is before" },
    are_not_specified: { value: "are_not_specified", label: "are not specified" },
    are_not_unspecified: { value: "are_not_unspecified", label: "are not unspecified" },
    include: { value: "include", label: "include" },
    do_not_include: { value: "do_not_include", label: "do not include" },
    are: { value: "are", label: "are" },
    is_not_specified: { value: "is_not_specified", label: "is not specified" },
    is_not_unspecified: { value: "is_not_unspecified", label: "is not unspecified" }
  };

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        measures: window.__measures || [],

        columns: [
          {enabled: true, title: "ID", field: "measure_sid"},
          {enabled: true, title: "Regulation", field: "regulation"},
          {enabled: true, title: "Type", field: "measure_type_id"},
          {enabled: true, title: "Valid from", field: "validity_start_date"},
          {enabled: true, title: "Valid to", field: "validity_end_date"},
          {enabled: true, title: "Commodity code", field: "goods_nomenclature_id"},
          {enabled: true, title: "Additional code", field: "additional_code_id"},
          {enabled: true, title: "Origin", field: "geographical_area"},
          {enabled: true, title: "Origin exclusions", field: "excluded_geographical_areas"},
          {enabled: true, title: "Duties", field: "duties"},
          {enabled: true, title: "Conditions", field: "conditions"},
          {enabled: true, title: "Footnotes", field: "footnotes"},
          {enabled: true, title: "Last updated", field: "last_updated"},
          {enabled: true, title: "Status", field: "status"}
        ],

        typesForDate: [
          { value: "creation", label: "creation" },
          { value: "authoring", label: "authoring" },
          { value: "last_status_change", label: "last status change" }
        ],

        conditionsForGroupName: [ conditions.is, conditions.starts_with, conditions.contains ],
        conditionsForStatus: [ conditions.is, conditions.is_not ],
        conditionsForAuthor: [ conditions.is, conditions.is_not ],
        conditionsForDate: [ conditions.is, conditions.is_after, conditions.is_before, conditions.is_not ],
        conditionsForLastUpdatedBy: [ conditions.is, conditions.is_not ],
        conditionsForRegulation: [ conditions.contains, conditions.does_not_contain, conditions.is, conditions.is_not ],
        conditionsForType: [ conditions.is, conditions.is_not ],
        conditionsForValidityStartDate: [ conditions.is, conditions.is_after, conditions.is_before, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified ],
        conditionsForValidityEndDate: [ conditions.is, conditions.is_after, conditions.is_before, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified ],
        conditionsForCommodityCode: [ conditions.is, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified, conditions.starts_with ],
        conditionsForAdditionalCode: [ conditions.is, conditions.is_not, conditions.starts_with ],
        conditionsForOrigin: [ conditions.is, conditions.is_not ],
        conditionsForOriginExclusions: [ conditions.are_not_specified, conditions.are_not_unspecified, conditions.include, conditions.do_not_include ],
        conditionsForDuties: [ conditions.are, conditions.include ],
        conditionsForConditions: [ conditions.are, conditions.are_not_specified, conditions.are_not_unspecified, conditions.include ],
        conditionsForFootnotes: [ conditions.are, conditions.are_not_specified, conditions.are_not_unspecified, conditions.include ],

        disableValue: [
          conditions.is_not_specified.value,
          conditions.is_not_unspecified.value,
          conditions.are_not_specified.value,
          conditions.are_not_unspecified.value
        ],

        statuses: [
          { value: "draft_incomplete", label: "Draft - incomplete" },
          { value: "draft_ready_for_cross_check", label: "Draft - ready for cross-check" },
          { value: "submitted_for_cross_check", label: "Submitted for cross-check" },
          { value: "cross_check_rejected", label: "Cross-check rejected" },
          { value: "ready_for_approval", label: "Ready for approval" },
          { value: "approval_rejected", label: "Approval rejected" },
          { value: "ready_for_export", label: "Ready for export" },
          { value: "export_pending", label: "Export pending" },
          { value: "sent_to_cds", label: "Sent to CDS" },
          { value: "cds_import_error", label: "CDS import error" },
          { value: "already_in_cds", label: "Already in CDS" }
        ],

        selectedMeasures: (window.__measures || []).map(function(m) { return m.measure_sid; })
      };

      var default_params = {
        group_name: {
          enabled: true,
          operator: "is",
          value: null
        },
        status: {
          enabled: true,
          operator: "is",
          value: null
        },
        author: {
          enabled: true,
          operator: "is",
          value: null
        },
        date_of: {
          enabled: true,
          operator: "is",
          value: null,
          mode: "creation"
        },
        last_updated_by: {
          enabled: true,
          operator: "is",
          value: null
        },
        regulation: {
          enabled: true,
          operator: "is",
          value: null
        },
        type: {
          enabled: true,
          operator: "is",
          value: null
        },
        validity_start_date: {
          enabled: true,
          operator: "is",
          value: null,
          mode: "creation"
        },
        validity_end_date: {
          enabled: true,
          operator: "is",
          value: null,
          mode: "creation"
        },
        commodity_code: {
          enabled: true,
          operator: "is",
          value: null
        },
        additional_code: {
          enabled: true,
          operator: "is",
          value: null
        },
        origin: {
          enabled: true,
          operator: "is",
          value: null
        },
        origin_exclusions: {
          enabled: true,
          operator: "include",
          value: [{value: ""}]
        },
        duties: {
          enabled: true,
          operator: "are",
          value: [{duty_expression_id: null, duty_amount: null}]
        },
        conditions: {
          enabled: true,
          operator: "are",
          value: [{
            measure_condition_code: null
          }]
        },
        footnotes: {
          enabled: true,
          operator: "are",
          value: [{
            footnote_type_id: null,
            footnote_id: null
          }]
        }
      };

      var fields = [
        "group_name",
        "status",
        "author",
        "date_of",
        "last_updated_by",
        "regulation",
        "type",
        "validity_start_date",
        "validity_end_date",
        "commodity_code",
        "additional_code",
        "origin",
        "origin_exclusions",
        "duties",
        "conditions",
        "footnotes"
      ];


      for (var k in fields) {
        var field = fields[k];

        data[field] = default_params[field];
      }

      if (window.__search_params.search !== undefined) {
        var params = window.__search_params.search;

        data.group_name.enabled = false;
        data.status.enabled = false;
        data.author.enabled = false;
        data.last_updated_by.enabled = false;
        data.regulation.enabled = false;
        data.date_of.enabled = false;
        data.type.enabled = false;
        data.validity_start_date.enabled = false;
        data.validity_end_date.enabled = false;
        data.commodity_code.enabled = false;
        data.additional_code.enabled = false;
        data.origin.enabled = false;
        data.origin_exclusions.enabled = false;
        data.duties.enabled = false;
        data.conditions.enabled = false;
        data.footnotes.enabled = false;

        if (params.group_name !== undefined) {
          data.group_name.enabled = params.group_name.enabled;

          if (params.group_name.enabled) {
            data.group_name = params.group_name;
          }
        }

        if (params.status !== undefined) {
          data.status.enabled = params.status.enabled;
          if (params.status.enabled) {
            data.status = params.status;
          }
        }

        if (params.author !== undefined) {
          data.author.enabled = params.author.enabled;
          if (params.author.enabled) {
            data.author = window.__search_params.search.author;
          }
        }

        if (params.date_of !== undefined) {
          data.date_of = params.date_of.enabled;
          if (params.date_of.enabled) {
            data.date_of = window.__search_params.search.date_of;
          }
        }

        if (params.last_updated_by !== undefined) {
          data.last_updated_by.enabled = params.last_updated_by.enabled;
          if (params.last_updated_by.enabled) {
            data.last_updated_by = window.__search_params.search.last_updated_by;
          }
        }

        if (params.regulation !== undefined) {
          data.regulation.enabled = params.regulation.enabled;

          if (params.regulation.enabled) {
            data.regulation = window.__search_params.search.regulation;
          }
        }

        if (params.type !== undefined) {
          data.type.enabled = params.type.enabled;

          if (params.type.enabled) {
            data.type = window.__search_params.search.type;
          }
        }

        if (params.valid_from !== undefined) {
          data.validity_start_date.enabled = params.valid_from.enabled;

          if (params.valid_from.enabled) {
            data.validity_start_date = window.__search_params.search.valid_from;
          }
        }

        if (params.valid_to !== undefined) {
          data.validity_end_date.enabled = params.valid_to.enabled;

          if (params.valid_to.enabled) {
            data.validity_end_date = window.__search_params.search.valid_to;
          }
        }

        if (params.commodity_code !== undefined) {
          data.commodity_code.enabled = params.commodity_code.enabled;

          if (params.commodity_code.enabled) {
            data.commodity_code = window.__search_params.search.commodity_code;
          }
        }

        if (params.additional_code !== undefined) {
          data.additional_code.enabled = params.additional_code.enabled;

          if (params.additional_code.enabled) {
            data.additional_code = window.__search_params.search.additional_code;
          }
        }

        if (params.origin !== undefined) {
          data.origin.enabled = params.origin.enabled;

          if (params.origin.enabled) {
            data.origin = window.__search_params.search.origin;
          }
        }

        if (params.origin_exclusions !== undefined) {
          data.origin_exclusions.enabled = params.origin_exclusions.enabled;

          if (params.origin_exclusions.enabled) {
            var c = window.__search_params.search.origin_exclusions.value;

            data.origin_exclusions = window.__search_params.search.origin_exclusions;
            data.origin_exclusions.value = [];

            for (var k in c) {
              if (!c.hasOwnProperty(k)) {
                continue;
              }

              data.origin_exclusions.value.push({
                value: c[k]
              });
            }
          }
        }

        if (params.duties !== undefined) {
          data.duties.enabled = params.duties.enabled;

          if (params.duties.enabled) {
            var d = window.__search_params.search.duties.value;

            data.duties = window.__search_params.search.duties;
            data.duties.value = [];

            for (var k in d) {
              if (!d.hasOwnProperty(k)) {
                continue;
              }

              var duty = {};

              for (var kk in d[k]) {
                if (!d[k].hasOwnProperty(kk)) {
                  continue;
                }

                duty.duty_expression_id = kk;
                duty.duty_amount = d[k][kk];
              }

              data.duties.value.push(duty);
            }
          }
        }

        if (params.conditions !== undefined) {
          data.conditions.enabled = params.conditions.enabled;

          if (params.conditions.enabled) {
            var c = window.__search_params.search.conditions.value;

            data.conditions = window.__search_params.search.conditions;
            data.conditions.value = [];

            for (var k in c) {
              if (!c.hasOwnProperty(k)) {
                continue;
              }

              data.conditions.value.push({
                measure_condition_code: c[k]
              });
            }
          }
        }

        if (params.footnotes !== undefined) {
          data.footnotes.enabled = params.footnotes.enabled;

          if (params.footnotes.enabled) {
            var f = window.__search_params.search.footnotes.value;

            data.footnotes = window.__search_params.search.footnotes;
            data.footnotes.value = [];

            for (var k in f) {
              if (!f.hasOwnProperty(k)) {
                continue;
              }

              for (var kk in f[k]) {
                if (!f[k].hasOwnProperty(kk)) {
                  continue;
                }

                data.footnotes.value.push({
                  footnote_type_id: kk,
                  footnote_id: f[k][kk]
                });
              }
            }
          }
        }
      }

      return data;
    },
    computed: {
      groupNameDisabled: function() {
        return !this.group_name.enabled;
      },
      statusDisabled: function() {
        return !this.status.enabled;
      },
      authorDisabled: function() {
        return !this.author.enabled;
      },
      dateDisabled: function() {
        return !this.date_of.enabled;
      },
      lastUpdatedByDisabled: function() {
        return !this.last_updated_by.enabled;
      },
      regulationDisabled: function() {
        return !this.regulation.enabled;
      },
      typeDisabled: function() {
        return !this.type.enabled;
      },
      validityStartDateDisabled: function() {
        return !this.validity_start_date.enabled;
      },
      validityEndDateDisabled: function() {
        return !this.validity_end_date.enabled;
      },
      commodityCodeDisabled: function() {
        return !this.commodity_code.enabled;
      },
      additionalCodeDisabled: function() {
        return !this.additional_code.enabled;
      },
      originDisabled: function() {
        return !this.origin.enabled;
      },
      originExclusionsDisabled: function() {
        return !this.origin_exclusions.enabled;
      },
      dutiesDisabled: function() {
        return !this.duties.enabled;
      },
      conditionsDisabled: function() {
        return !this.conditions.enabled;
      },
      footnotesDisabled: function() {
        return !this.footnotes.enabled;
      },
      noSelectedMeasures: function() {
        return this.selectedMeasures.length === 0;
      },

      validityStartDateValueDisabled: function() {
        return this.validityStartDateDisabled || this.disableValue.indexOf(this.validity_start_date.operator) > -1;
      },
      validityEndDateValueDisabled: function() {
        return this.validityEndDateDisabled || this.disableValue.indexOf(this.validity_end_date.operator) > -1;
      },
      commodityCodeValueDisabled: function() {
        return this.commodityCodeDisabled || this.disableValue.indexOf(this.commodity_code.operator) > -1;
      },
      conditionsValueDisabled: function() {
        return this.conditionsDisabled || this.disableValue.indexOf(this.conditions.operator) > -1;
      },
      footnotesValueDisabled: function() {
        return this.footnotesDisabled || this.disableValue.indexOf(this.footnotes.operator) > -1;
      },
      exclusionsValueDisabled: function () {
        return this.originExclusionsDisabled || this.disableValue.indexOf(this.origin_exclusions.operator) > -1;
      },
    },
    methods: {
      addOriginExclusion: function() {
        this.origin_exclusions.value.push({ value: '' });
      },
      addDuty: function() {
        this.duties.value.push({
          duty_expression_id: null
        });
      },
      addFootnote: function() {
        this.footnotes.value.push({
          footnote_type_id: null,
          footnote_id: null
        });
      },
      addCondition: function() {
        this.conditions.value.push({
          measure_condition_code: null
        });
      },
      onMeasuresSelected: function(sids) {
        this.selectedMeasures = sids;
      },
      expressionsFriendlyDuplicate: function(options) {
        return DutyExpressionsParser.parse(options);
      }
    }
  });
});
