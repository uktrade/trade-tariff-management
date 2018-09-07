//= require ./duty-expressions-parser
//= require ./url-parser

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
    is_after_or_nil: { value: "is_after_or_nil", label: "is after or not specified" },
    is_before: { value: "is_before", label: "is before" },
    is_before_or_nil: { value: "is_before_or_nil", label: "is before or not specified" },
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
      var params = parseQueryString(window.location.search.substring(1));
      var code = params.search_code;

      var data = {
        columns: [
          {enabled: true, title: "ID", field: "measure_sid"},
          {enabled: true, title: "Regulation", field: "regulation"},
          {enabled: true, title: "Type", field: "measure_type_id"},
          {enabled: true, title: "Start date", field: "validity_start_date"},
          {enabled: true, title: "End date", field: "validity_end_date"},
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

        conditionsForMeasureSid: [ conditions.is, conditions.starts_with, conditions.contains ],
        conditionsForGroupName: [ conditions.is, conditions.starts_with, conditions.contains ],
        conditionsForStatus: [ conditions.is, conditions.is_not ],
        conditionsForAuthor: [ conditions.is, conditions.is_not ],
        conditionsForDate: [ conditions.is, conditions.is_after, conditions.is_before, conditions.is_not ],
        conditionsForLastUpdatedBy: [ conditions.is, conditions.is_not ],
        conditionsForRegulation: [ conditions.contains, conditions.does_not_contain, conditions.is, conditions.is_not ],
        conditionsForType: [ conditions.is, conditions.is_not ],
        conditionsForValidityStartDate: [ conditions.is, conditions.is_after, conditions.is_before, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified ],
        conditionsForValidityEndDate: [ conditions.is, conditions.is_after, conditions.is_after_or_nil, conditions.is_before, conditions.is_before_or_nil, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified ],
        conditionsForCommodityCode: [ conditions.is, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified, conditions.starts_with ],
        conditionsForAdditionalCode: [ conditions.is, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified, conditions.starts_with ],
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
          { value: "new_in_progress", label: "New - in progress" },
          { value: "editing", label: "Editing" },
          { value: "awaiting_cross_check", label: "Awaiting cross-check" },
          { value: "cross_check_rejected", label: "Cross-check rejected" },
          { value: "ready_for_approval", label: "Ready for approval" },
          { value: "awaiting_approval", label: "Awaiting approval" },
          { value: "approval_rejected", label: "Approval rejected" },
          { value: "ready_for_export", label: "Ready for export" },
          { value: "awaiting_cds_upload_create_new", label: "Awaiting CDS upload - create new" },
          { value: "awaiting_cds_upload_edit", label: "Awaiting CDS upload - edit" },
          { value: "awaiting_cds_upload_overwrite", label: "Awaiting CDS upload - overwrite" },
          { value: "awaiting_cds_upload_delete", label: "Awaiting CDS upload - delete" },
          { value: "sent_to_cds", label: "Sent to CDS" },
          { value: "sent_to_cds_delete", label: "Sent to CDS - delete" },
          { value: "published", label: "Published" },
          { value: "cds_error", label: "CDS error" }
        ],

        searchCode: code,
        pagesLoaded: JSON.parse((window.localStorage.getItem(code + "_pages") || "[]")).map(function(n) { return parseInt(n, 10) }),
        selectedMeasures: JSON.parse((window.localStorage.getItem(code + "_measure_sids") || "[]")),
        selectionType: window.localStorage.getItem(code + "_selection_type") || "all",
        pagination: {
          page: 1,
          total_count: 0,
          per_page: 25
        },
        measures: [],
        isLoading: true,
      };

      var default_params = {
        measure_sid: {
          enabled: true,
          operator: "is",
          value: null
        },
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
        "measure_sid",
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

      if (window.__pagination_metadata) {
        data.pagination = window.__pagination_metadata;
        data.pagination.page = parseInt(data.pagination.page, 10);
      }

      for (var k in fields) {
        var field = fields[k];

        data[field] = default_params[field];
      }

      if (window.__search_params) {
        var params = window.__search_params;

        var mapping = {
          measure_sid: "measure_sid",
          group_name: "group_name",
          status: "status",
          author: "author",
          date_of: "date_of",
          last_updated_by: "last_updated_by",
          regulation: "regulation",
          type: "type",
          valid_from: "validity_start_date",
          valid_to: "validity_end_date",
          commodity_code: "commodity_code",
          additional_code: "additional_code",
          origin: "origin"
        };

        for (var k in mapping) {
          if (!mapping.hasOwnProperty(k)) {
            continue;
          }

          var v = mapping[k];

          data[v].enabled = false;

          if (params[k] !== undefined) {
            data[v].enabled = params[k].enabled;

            if (params[k].enabled) {
              data[v] = params[k];
            }
          }
        }

        data.origin_exclusions.enabled = false;
        data.conditions.enabled = false;
        data.duties.enabled = false;
        data.footnotes.enabled = false;

        if (params.origin_exclusions !== undefined) {
          data.origin_exclusions.enabled = params.origin_exclusions.enabled;

          if (params.origin_exclusions.enabled) {
            var c = params.origin_exclusions.value;

            data.origin_exclusions = params.origin_exclusions;
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
            var d = params.duties.value;

            data.duties = params.duties;
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
            var c = params.conditions.value;

            data.conditions = params.conditions;
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
            var f = params.footnotes.value;

            data.footnotes = params.footnotes;
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
      measureSidDisabled: function() {
        return !this.measure_sid.enabled;
      },
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
        return (this.selectionType == "all" && this.selectedMeasures.length === this.pagination.total_count) ||
               (this.selectionType == "none" && this.selectedMeasures.length === 0);
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
      }
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
      onMeasuresSelected: function(sid) {
        if (this.selectionType !== "none") {
          var index = this.selectedMeasures.indexOf(sid);

          if (index === -1) {
            return;
          }

          this.selectedMeasures.splice(index, 1);
        } else {
          this.selectedMeasures.push(sid);
        }
      },
      onMeasuresDeselected: function(sid) {
        if (this.selectionType != "none") {
          this.selectedMeasures.push(sid);
        } else {
          var index = this.selectedMeasures.indexOf(sid);

          if (index === -1) {
            return;
          }

          this.selectedMeasures.splice(index, 1);
        }
      },
      expressionsFriendlyDuplicate: function(options) {
        return DutyExpressionsParser.parse(options);
      },
      onPageChange: function(page) {
        var self = this;

        var params = parseQueryString(window.location.search.substring(1));
        params.page = page;
        this.pagination.page = page;

        var newQueryString = "?search_code=" + params.search_code + "&page=" + params.page;

        window.history.pushState(params, "Find a measure - Page " + page, newQueryString);

        this.loadMeasures(function() {
          self.scrollUp();
        });
      },
      loadMeasures: function(callback) {
        var self = this;

        this.isLoading = true;

        $.get(window.location.href).success(function(data) {
          self.measures = data.measures;
          self.isLoading = false;

          if (callback) {
            callback();
          }
        }).fail(function(error) {
          var params = parseQueryString(window.location.href);
          var page = params.page || 1;

          alert("There was a problem loading page " + page);
          window.history.back();

          if (callback) {
            callback();
          }
        });
      },
      scrollUp: function() {
        var self = this;

        setTimeout(function() {
          $("html,body").animate({
            scrollTop: $(".measures-table-wrapper").offset().top - 200
          });
        }, 200);
      },
      changeSelectionType: function(selectAll) {
        this.selectionType = selectAll ? "all" : "none";
      }
    },
    mounted: function() {
      var self = this;

      if (window.__search_params) {
        this.loadMeasures();
      }

      window.onpopstate = function(event) {
        self.scrollUp();
        self.loadMeasures();
      };
    },
    watch: {
      pagesLoaded: function(newVal) {
        window.localStorage.setItem(this.searchCode + "_pages", JSON.stringify(newVal));
      },
      selectedMeasures: function(newVal, oldVal) {
        window.localStorage.setItem(this.searchCode + "_measure_sids", JSON.stringify(newVal));
      },
      selectionType: function(val) {
        this.selectedMeasures.splice(0, this.selectedMeasures.length);
        window.localStorage.setItem(this.searchCode + "_selection_type", val);
      }
    }
  });
});
