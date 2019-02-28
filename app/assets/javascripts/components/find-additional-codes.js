//= require ./url-parser

$(document).ready(function() {
  var form = document.querySelector(".find-additional-codes");

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
          {enabled: true, title: "Type", field: "type_id", sortable: true, type: "string" },
          {enabled: true, title: "Code", field: "additional_code", sortable: true, type: "string" },
          {enabled: true, title: "Description", field: "description", sortable: true, type: "string" },
          {enabled: true, title: "Valid from", field: "validity_start_date", sortable: true, type: "date" },
          {enabled: true, title: "Valid to", field: "validity_end_date", sortable: true, type: "date" },
          {enabled: true, title: "Last updated", field: "last_updated", sortable: true, type: "string" },
          {enabled: true, title: "Status", field: "status", sortable: true, type: "string", changeProp: "status" }
        ],

        typesForDate: [
          { value: "creation", label: "creation" },
          { value: "authoring", label: "authoring" },
          { value: "last_status_change", label: "last status change" }
        ],

        conditionsForWorbasketName: [ conditions.is, conditions.starts_with, conditions.contains ],
        conditionsForStatus: [ conditions.is, conditions.is_not ],
        conditionsForAuthor: [ conditions.is, conditions.is_not ],
        conditionsForDate: [ conditions.is, conditions.is_after, conditions.is_before, conditions.is_not ],
        conditionsForLastUpdatedBy: [ conditions.is, conditions.is_not ],
        conditionsForType: [ conditions.is, conditions.is_not ],
        conditionsForValidityStartDate: [ conditions.is, conditions.is_after, conditions.is_before, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified ],
        conditionsForValidityEndDate: [ conditions.is, conditions.is_after, conditions.is_after_or_nil, conditions.is_before, conditions.is_before_or_nil, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified ],
        conditionsForDescription: [ conditions.is, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified, conditions.starts_with ],
        conditionsForCode: [ conditions.is, conditions.is_not, conditions.is_not_specified, conditions.is_not_unspecified, conditions.starts_with ],

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
        selectedItems: JSON.parse((window.localStorage.getItem(code + "_sids") || "[]")),
        selectionType: window.localStorage.getItem(code + "_selection_type") || "all",
        pagination: {
          page: 1,
          total_count: 0,
          per_page: 25
        },
        items: [],
        isLoading: true,
      };

      var default_params = {
        workbasket_name: {
          enabled: false,
          operator: "is",
          value: null
        },
        description: {
          enabled: false,
          operator: "is",
          value: null
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
        type: {
          enabled: false,
          operator: "is",
          value: null
        },
        valid_from: {
          enabled: false,
          operator: "is",
          value: null,
          mode: "creation"
        },
        valid_to: {
          enabled: false,
          operator: "is",
          value: null,
          mode: "creation"
        },
        code: {
          enabled: false,
          operator: "is",
          value: null
        }
      };

      var fields = [
        "workbasket_name",
        "status",
        "author",
        "date_of",
        "last_updated_by",
        "type",
        "valid_from",
        "valid_to",
        "code",
        "description"
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
          workbasket_name: "workbasket_name",
          status: "status",
          author: "author",
          date_of: "date_of",
          last_updated_by: "last_updated_by",
          description: "description",
          type: "type",
          valid_from: "valid_from",
          valid_to: "valid_to",
          code: "code"
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
      }

      return data;
    },
    computed: {
      noSelectedItems: function() {
        return (this.selectionType == "all" && this.selectedItems.length === this.pagination.total_count) ||
               (this.selectionType == "none" && this.selectedItems.length === 0);
      },

      validityStartDateValueDisabled: function() {
        return this.disableValue.indexOf(this.valid_from.operator) > -1;
      },
      validityEndDateValueDisabled: function() {
        return this.disableValue.indexOf(this.valid_to.operator) > -1;
      },
      codeValueDisabled: function() {
        return this.disableValue.indexOf(this.code.operator) > -1;
      },
      descriptionValueDisabled: function() {
        return this.disableValue.indexOf(this.description.operator) > -1;
      }
    },
    methods: {
      onItemsSelected: function(sid) {
        if (this.selectionType !== "none") {
          var index = this.selectedItems.indexOf(sid);

          if (index === -1) {
            return;
          }

          this.selectedItems.splice(index, 1);
        } else {
          this.selectedItems.push(sid);
        }
      },
      onItemsDeselected: function(sid) {
        if (this.selectionType != "none") {
          this.selectedItems.push(sid);
        } else {
          var index = this.selectedItems.indexOf(sid);

          if (index === -1) {
            return;
          }

          this.selectedItems.splice(index, 1);
        }
      },
      onPageChange: function(page) {
        var self = this;

        var params = parseQueryString(window.location.search.substring(1));
        params.page = page;
        this.pagination.page = page;

        var newQueryString = "?search_code=" + params.search_code + "&page=" + params.page;

        window.history.pushState(params, "Find and edit additional codes - Page " + page, newQueryString);

        this.loadItems(function() {
          self.scrollUp();
        });
      },
      loadItems: function(callback) {
        var self = this;

        this.isLoading = true;
        var search = window.location.search;
        var url = window.location.href.replace(search, "") + ".json" + search;

        $.get(url).success(function(data) {
          //todo: refactor this root element out
          self.items = data.collection;
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
            scrollTop: $(".items-table-wrapper").offset().top - 200
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
        this.loadItems();
      }

      window.onpopstate = function(event) {
        self.scrollUp();
        self.loadItems();
      };
    },
    watch: {
      pagesLoaded: function(newVal) {
        window.localStorage.setItem(this.searchCode + "_pages", JSON.stringify(newVal));
      },
      selectedItems: function(newVal, oldVal) {
        window.localStorage.setItem(this.searchCode + "_measure_sids", JSON.stringify(newVal));
      },
      selectionType: function(val) {
        this.selectedItems.splice(0, this.selectedItems.length);
        window.localStorage.setItem(this.searchCode + "_selection_type", val);
      },
      "workbasket_name.operator": function(val) {
        if (val) {
          this.workbasket_name.enabled = true;
        }
      },
      "workbasket_name.value": function(val) {
        if (val) {
          this.workbasket_name.enabled = true;
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
      "valid_from.operator": function(val) {
        if (val) {
          this.valid_from.enabled = true;
        }
      },
      "valid_from.value": function(val) {
        if (val) {
          this.valid_from.enabled = true;
        }
      },
      "valid_to.operator": function(val) {
        if (val) {
          this.valid_to.enabled = true;
        }
      },
      "valid_to.value": function(val) {
        if (val) {
          this.valid_to.enabled = true;
        }
      },
      "code.operator": function(val) {
        if (val) {
          this.code.enabled = true;
        }
      },
      "code.value": function(val) {
        if (val) {
          this.code.enabled = true;
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
