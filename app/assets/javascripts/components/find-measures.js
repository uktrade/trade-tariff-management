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
    does_not_include: { value: "does_not_include", label: "include" },
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
        conditionsForOriginExclusions: [ conditions.are_not_specified, conditions.are_not_unspecified, conditions.include, conditions.does_not_include ],
        conditionsForDuties: [ conditions.are, conditions.include ],
        conditionsForConditions: [ conditions.are, conditions.are_not_specified, conditions.are_not_unspecified, conditions.include ],
        conditionsForFootnotes: [ conditions.are, conditions.are_not_specified, conditions.are_not_unspecified, conditions.include ],

        statuses: [
          { value: "draft", label: "Draft - incomplete" },
          { value: "ready_for_crosscheck", label: "Draft - ready for cross-check" },
          { value: "submitted", label: "Submitted for cross-check" },
          { value: "cross_check_rejected", label: "Cross-check rejected" },
          { value: "ready_for_approval", label: "Ready for approval" },
          { value: "approval_rejected", label: "Approval rejected" },
          { value: "ready_for_export", label: "Ready for export" },
          { value: "export_pending", label: "Export pending" },
          { value: "sent_to_cds", label: "Sent to CDS" },
          { value: "cds_import_error", label: "CDS import error" },
          { value: "already_in_cds", label: "Already in CDS" }
        ],

        selectedMeasures: []
      };

      var default_params = {
        group_name: {
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
          operator: "is",
          value: null,
          mode: "creation"
        },
        validity_end_date: {
          enabled: false,
          operator: "is",
          value: null,
          mode: "creation"
        },
        commodity_code: {
          enabled: false,
          operator: "is",
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
          operator: "include",
          value: []
        },
        duties: {
          enabled: false,
          operator: "are",
          value: null
        },
        conditions: {
          enabled: false,
          operator: "are",
          value: null
        },
        footnotes: {
          enabled: false,
          operator: "are",
          value: null
        }
      };

      if (window.__search_params.search !== undefined && window.__search_params.search.group_name !== undefined) {
        data.group_name = window.__search_params.search.group_name;
      } else {
        data.group_name = default_params.group_name
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.status !== undefined) {
        data.status = window.__search_params.search.status;
      } else {
        data.status = default_params.status
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.author !== undefined) {
        data.author = window.__search_params.search.author;
      } else {
        data.author = default_params.author
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.date_of !== undefined) {
        data.date_of = window.__search_params.search.date_of;
      } else {
        data.date_of = default_params.date_of
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.last_updated_by !== undefined) {
        data.last_updated_by = window.__search_params.search.last_updated_by;
      } else {
        data.last_updated_by = default_params.last_updated_by
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.regulation !== undefined) {
        data.regulation = window.__search_params.search.regulation;
      } else {
        data.regulation = default_params.regulation
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.type !== undefined) {
        data.type = window.__search_params.search.type;
      } else {
        data.type = default_params.type
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.validity_start_date !== undefined) {
        data.validity_start_date = window.__search_params.search.validity_start_date;
      } else {
        data.validity_start_date = default_params.validity_start_date
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.validity_end_date !== undefined) {
        data.validity_end_date = window.__search_params.search.validity_end_date;
      } else {
        data.validity_end_date = default_params.validity_end_date
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.commodity_code !== undefined) {
        data.commodity_code = window.__search_params.search.commodity_code;
      } else {
        data.commodity_code = default_params.commodity_code
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.additional_code !== undefined) {
        data.additional_code = window.__search_params.search.additional_code;
      } else {
        data.additional_code = default_params.additional_code
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.origin !== undefined) {
        data.origin = window.__search_params.search.origin;
      } else {
        data.origin = default_params.origin
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.origin_exclusions !== undefined) {
        data.origin_exclusions = window.__search_params.search.origin_exclusions;
      } else {
        data.origin_exclusions = default_params.origin_exclusions
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.duties !== undefined) {
        data.duties = window.__search_params.search.duties;
      } else {
        data.duties = default_params.duties
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.conditions !== undefined) {
        data.conditions = window.__search_params.search.conditions;
      } else {
        data.conditions = default_params.conditions
      }

      if (window.__search_params.search !== undefined && window.__search_params.search.footnotes !== undefined) {
        data.footnotes = window.__search_params.search.footnotes;
      } else {
        data.footnotes = default_params.footnotes
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
      }
    },
    methods: {
      addOriginExclusion: function() {
        this.origin_exclusions.push({ value: '' });
      },
      onMeasuresSelected: function(sids) {
        this.selectedMeasures = sids;
      }
    }
  });
});
