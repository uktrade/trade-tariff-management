//= require ./url-parser

$(document).ready(function() {
  var form = document.querySelector(".find-quotas");

  if (!form) {
    return;
  }

  var conditions = {
    is: { value: "is", label: "is" },
    on: { value: "on", label: "on" },
    is_not: { value: "is_not", label: "is not" },
    starts_with: { value: "starts_with", label: "starts with" },
    contains: { value: "contains", label: "contains" },
    does_not_contain: { value: "does_not_contain", label: "does not contain" },
    after: { value: "after", label: "after" },
    is_after: { value: "is_after", label: "is after" },
    is_after_or_nil: { value: "is_after_or_nil", label: "is after or not specified" },
    before: { value: "before", label: "before" },
    is_before: { value: "is_before", label: "is before" },
    is_before_or_nil: { value: "is_before_or_nil", label: "is before or not specified" },
    are_not_specified: { value: "are_not_specified", label: "are not specified" },
    are_not_unspecified: { value: "are_not_unspecified", label: "are not unspecified" },
    include: { value: "include", label: "include" },
    includes: { value: "includes", label: "includes" },
    do_not_include: { value: "do_not_include", label: "do not include" },
    are: { value: "are", label: "are" },
    is_not_specified: { value: "is_not_specified", label: "is not specified" },
    is_not_unspecified: { value: "is_not_unspecified", label: "is not unspecified" },
    no: { value: "no", label: "no" },
    yes: { value: "yes", label: "yes" }
  };

  var app = new Vue({
    el: form,
    data: function() {
      var params = parseQueryString(window.location.search.substring(1));
      var code = params.search_code;

      var data = {
        columns: [
          {enabled: true, title: "Order number", field: "quota_order_number_id"},
          {enabled: true, title: "Type", field: "quota_type_id"},
          {enabled: true, title: "Regulation", field: "regulation_id"},
          {enabled: true, title: "License", field: "license"},
          {enabled: true, title: "Starts", field: "validity_start_date"},
          {enabled: true, title: "Ends", field: "validity_end_date"},
          {enabled: true, title: "Commodity code(s)", field: "goods_nomenclature_item_ids"},
          {enabled: true, title: "Additional code(s)", field: "additional_code_ids"},
          {enabled: true, title: "Origin", field: "origin"},
          {enabled: true, title: "Origin exclusions", field: "origin_exclusions"},
          {enabled: true, title: "Status", field: "status"}
        ],

        typesForDate: [
          { value: "creation", label: "creation" },
          { value: "authoring", label: "authoring" },
          { value: "last_status_change", label: "last status change" }
        ],

        conditionsForOrderNumber: [ conditions.is, conditions.starts_with, conditions.contains ],
        conditionsForDescription: [ conditions.is, conditions.starts_with, conditions.contains ],
        conditionsForType: [ conditions.is, conditions.is_not ],
        conditionsForRegulation: [ conditions.contains, conditions.does_not_contain, conditions.is, conditions.is_not ],
        conditionsForLicense: [ conditions.no, conditions.yes ],
        conditionsForValidityStartDate: [ conditions.after, conditions.before, conditions.on ],
        conditionsForValidityEndDate: [ conditions.after, conditions.before, conditions.on ],
        conditionsForStaged: [ conditions.no, conditions.yes ],
        conditionsForCommodityCode: [ conditions.includes, conditions.is, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified, conditions.starts_with ],
        conditionsForAdditionalCode: [ conditions.is, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified, conditions.starts_with ],
        conditionsForOrigin: [ conditions.is, conditions.is_not ],
        conditionsForOriginExclusions: [ conditions.are_not_specified, conditions.are_not_unspecified, conditions.include, conditions.do_not_include ],
        conditionsForStatus: [ conditions.is, conditions.is_not ],
        conditionsForAuthor: [ conditions.is, conditions.is_not ],
        conditionsForDate: [ conditions.is, conditions.is_after, conditions.is_before, conditions.is_not ],
        conditionsForLastUpdatedBy: [ conditions.is, conditions.is_not ],

        disableValue: [
          conditions.is_not_specified.value,
          conditions.is_not_unspecified.value,
          conditions.are_not_specified.value,
          conditions.are_not_unspecified.value,
          conditions.no.value
        ],

        statuses: [
          { value: "new_in_progress", label: "New - in progress" },
          { value: "editing", label: "Editing" },
          { value: "awaiting_cross_check", label: "Awaiting cross-check" },
          { value: "cross_check_rejected", label: "Cross-check rejected" },
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
        selectedItem: null,
        pagination: {
          page: 1,
          total_count: 0,
          per_page: 25
        },
        quotas: [],
        isLoading: true,
      };

      var default_params = {
        order_number: {
          enabled: false,
          operator: "is",
          value: null
        },
        description: {
          enabled: false,
          operator: "contains",
          value: null
        },
        license: {
          enabled: false,
          operator: "no",
          value: null
        },
        staged: {
          enabled: false,
          operator: "no"
        },
        status: {
          enabled: false,
          operator: "is",
          value: null
        },
        author: {
          enabled: false,
          operator: "is",
          value: null
        },
        date_of: {
          enabled: false,
          operator: "is",
          value: null,
          mode: "creation"
        },
        last_updated_by: {
          enabled: false,
          operator: "is",
          value: null
        },
        regulation: {
          enabled: false,
          operator: "is",
          value: null
        },
        type: {
          enabled: false,
          operator: "is",
          value: null
        },
        validity_start_date: {
          enabled: false,
          operator: "on",
          value: null,
          mode: "creation"
        },
        validity_end_date: {
          enabled: false,
          operator: "on",
          value: null,
          mode: "creation"
        },
        commodity_code: {
          enabled: false,
          operator: "includes",
          value: null
        },
        additional_code: {
          enabled: false,
          operator: "is",
          value: null
        },
        origin: {
          enabled: false,
          operator: "is",
          value: null
        },
        origin_exclusions: {
          enabled: false,
          operator: "are_not_specified",
          value: [{value: ""}]
        }
      };

      var fields = [
        "order_number",
        "description",
        "license",
        "staged",
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
        "origin_exclusions"
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
          order_number: "order_number",
          description: "description",
          license: "license",
          staged: "staged",
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
      }

      return data;
    },
    computed: {
      noSelectedQuota: function() {
        return !this.selectedItem;
      },

      validityStartDateValueDisabled: function() {
        return this.disableValue.indexOf(this.validity_start_date.operator) > -1;
      },
      validityEndDateValueDisabled: function() {
        return this.disableValue.indexOf(this.validity_end_date.operator) > -1;
      },
      commodityCodeValueDisabled: function() {
        return this.disableValue.indexOf(this.commodity_code.operator) > -1;
      },
      exclusionsValueDisabled: function () {
        return this.disableValue.indexOf(this.origin_exclusions.operator) > -1;
      },
      licenseValueDisabled: function () {
        return this.disableValue.indexOf(this.license.operator) > -1;
      }
    },
    methods: {
      addOriginExclusion: function() {
        this.origin_exclusions.value.push({ value: '' });
      },
      onQuotasSelected: function(sid) {
        this.selectedItem = sid;
      },
      onQuotasDeselected: function(sid) {
        console.log("fix before can remove this")
      },
      onPageChange: function(page) {
        var self = this;

        var params = parseQueryString(window.location.search.substring(1));
        params.page = page;
        this.pagination.page = page;

        var newQueryString = "?search_code=" + params.search_code + "&page=" + params.page;

        window.history.pushState(params, "Find a quota - Page " + page, newQueryString);

        this.loadQuotas(function() {
          self.scrollUp();
        });
      },
      loadQuotas: function(callback) {
        var self = this;

        this.isLoading = true;
        var search = window.location.search;
        var url = window.location.href.replace(search, "") + ".json" + search;

        $.get(url).success(function(data) {
          self.quotas = data.collection;
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
            scrollTop: $(".records-table").offset().top - 200
          });
        }, 200);
      },
      changeSelectionType: function(selectAll) {
        this.selectionType = selectAll ? "all" : "none";
      },
      exclusionsChanged: function() {
        var selected = any(this.origin_exclusions.value, function(oe) {
          return oe.value;
        });

        if (selected) {
          this.origin_exclusions.enabled = true;
        }
      },
    },
    mounted: function() {
      var self = this;

      if (window.__search_params) {
        this.loadQuotas();
      }

      window.onpopstate = function(event) {
        self.scrollUp();
        self.loadQuotas();
      };
    },
    watch: {
      pagesLoaded: function(newVal) {
        window.localStorage.setItem(this.searchCode + "_pages", JSON.stringify(newVal));
      },
      selectedQuotas: function(newVal, oldVal) {
        window.localStorage.setItem(this.searchCode + "_quota_sids", JSON.stringify(newVal));
      },
      selectionType: function(val) {
        this.selectedQuotas.splice(0, this.selectedQuotas.length);
        window.localStorage.setItem(this.searchCode + "_selection_type", val);
      },
      "order_number.operator": function(val) {
        if (val) {
          this.order_number.enabled = true;
        }
      },
      "order_number.value": function(val) {
        if (val) {
          this.order_number.enabled = true;
        }
      },
      "description.operator": function(val) {
        if (val) {
          this.description.enabled = true;
        }
      },
      "description.value": function(val) {
        if (val) {
          this.description.enabled = true;
        }
      },
      "type.operator": function(val) {
        if (val) {
          this.type.enabled = true;
        }
      },
      "type.value": function(val) {
        if (val) {
          this.type.enabled = true;
        }
      },
      "regulation.operator": function(val) {
        if (val) {
          this.regulation.enabled = true;
        }
      },
      "regulation.value": function(val) {
        if (val) {
          this.regulation.enabled = true;
        }
      },
      "validity_start_date.operator": function(val) {
        if (val) {
          this.validity_start_date.enabled = true;
        }
      },
      "validity_start_date.value": function(val) {
        if (val) {
          this.validity_start_date.enabled = true;
        }
      },
      "validity_end_date.operator": function(val) {
        if (val) {
          this.validity_end_date.enabled = true;
        }
      },
      "validity_end_date.value": function(val) {
        if (val) {
          this.validity_end_date.enabled = true;
        }
      },
      "commodity_code.operator": function(val) {
        if (val) {
          this.commodity_code.enabled = true;
        }
      },
      "commodity_code.value": function(val) {
        if (val) {
          this.commodity_code.enabled = true;
        }
      },
      "additional_code.operator": function(val) {
        if (val) {
          this.additional_code.enabled = true;
        }
      },
      "additional_code.value": function(val) {
        if (val) {
          this.additional_code.enabled = true;
        }
      },
      "origin.operator": function(val) {
        if (val) {
          this.origin.enabled = true;
        }
      },
      "origin.value": function(val) {
        if (val) {
          this.origin.enabled = true;
        }
      },
      "origin_exclusions.operator": function(val) {
        if (val) {
          this.origin_exclusions.enabled = true;
        }
      },
      "origin_exclusions.value": function(val) {
        if (val) {
          this.origin_exclusions.enabled = true;
        }
      },
      "license.operator": function(val) {
        if (val) {
          this.license.enabled = true;
        }
      },
      "license.value": function(val) {
        if (val) {
          this.license.enabled = true;
        }
      },
      "staged.operator": function(val) {
        if (val) {
          this.staged.enabled = true;
        }
      },
      "staged.value": function(val) {
        if (val) {
          this.staged.enabled = true;
        }
      },
      "status.operator": function(val) {
        if (val) {
          this.status.enabled = true;
        }
      },
      "status.value": function(val) {
        if (val) {
          this.status.enabled = true;
        }
      },
      "author.value": function(val) {
        if (val) {
          this.author.enabled = true;
        }
      },
      "date_of.mode": function(val) {
        if (val) {
          this.date_of.enabled = true;
        }
      },
      "date_of.operator": function(val) {
        if (val) {
          this.date_of.enabled = true;
        }
      },
      "date_of.value": function(val) {
        if (val) {
          this.date_of.enabled = true;
        }
      },
      "last_updated_by.value": function(val) {
        if (val) {
          this.last_updated_by.enabled = true;
        }
      }
    }
  });
});
