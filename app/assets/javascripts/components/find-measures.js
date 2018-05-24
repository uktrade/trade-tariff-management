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
      return {
        groupNameEnabled: false,
        statusEnabled: false,
        authorEnabled: false,
        dateEnabled: false,
        lastUpdatedByEnabled: false,
        regulationEnabled: false,
        typeEnabled: false,
        validityStartDateEnabled: false,
        validityEndDateEnabled: false,
        commodityCodeEnabled: false,
        additionalCodeEnabled: false,
        originEnabled: false,
        originExclusionsEnabled: false,
        dutiesEnabled: false,
        conditionsEnabled: false,
        footnotesEnabled: false,

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

        groupNameCondition: "is",
        groupName: null,
        statusCondition: "is",
        status: null,
        authorCondition: "is",
        author: null,
        dateType: null,
        dateCondition: "is",
        date: null,
        lastUpdatedByCondition: "is",
        lastUpdatedBy: null,
        regulationCondition: "is",
        regulation: null,
        typeCondition: "is",
        type: null,
        validityStartDateCondition: "is",
        validityStartDate: null,
        validityEndDateCondition: "is",
        validityEndDate: null,
        commodityCodeCondition: "is",
        commodityCode: null,
        additionalCodeCondition: "is",
        additionalCode: null,
        originCondition: "is",
        origin: null,
        originExclusionsCondition: "include",
        dutiesCondition: "are",
        conditionsCondition: "are",
        footnotesCondition: "are",
        validityStartDateType: null,
        validityEndDateType: null,

        origin_exclusions: [ { value: '' } ],
        footnotes: [ { type: '', id: '' } ],

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
          { value: "cds_import_error", label: "CDS import error" }
        ],

        selectedMeasures: []
      };
    },
    computed: {
      groupNameDisabled: function() {
        return !this.groupNameEnabled;
      },
      groupNameDisabled: function() {
        return !this.groupNameEnabled;
      },
      statusDisabled: function() {
        return !this.statusEnabled;
      },
      statusDisabled: function() {
        return !this.statusEnabled;
      },
      authorDisabled: function() {
        return !this.authorEnabled;
      },
      authorDisabled: function() {
        return !this.authorEnabled;
      },
      dateDisabled: function() {
        return !this.dateEnabled;
      },
      dateDisabled: function() {
        return !this.dateEnabled;
      },
      lastUpdatedByDisabled: function() {
        return !this.lastUpdatedByEnabled;
      },
      lastUpdatedByDisabled: function() {
        return !this.lastUpdatedByEnabled;
      },
      regulationDisabled: function() {
        return !this.regulationEnabled;
      },
      regulationDisabled: function() {
        return !this.regulationEnabled;
      },
      typeDisabled: function() {
        return !this.typeEnabled;
      },
      typeDisabled: function() {
        return !this.typeEnabled;
      },
      validityStartDateDisabled: function() {
        return !this.validityStartDateEnabled;
      },
      validityStartDateDisabled: function() {
        return !this.validityStartDateEnabled;
      },
      validityEndDateDisabled: function() {
        return !this.validityEndDateEnabled;
      },
      validityEndDateDisabled: function() {
        return !this.validityEndDateEnabled;
      },
      commodityCodeDisabled: function() {
        return !this.commodityCodeEnabled;
      },
      commodityCodeDisabled: function() {
        return !this.commodityCodeEnabled;
      },
      additionalCodeDisabled: function() {
        return !this.additionalCodeEnabled;
      },
      additionalCodeDisabled: function() {
        return !this.additionalCodeEnabled;
      },
      originDisabled: function() {
        return !this.originEnabled;
      },
      originDisabled: function() {
        return !this.originEnabled;
      },
      originExclusionsDisabled: function() {
        return !this.originExclusionsEnabled;
      },
      dutiesDisabled: function() {
        return !this.dutiesEnabled;
      },
      conditionsDisabled: function() {
        return !this.conditionsEnabled;
      },
      footnotesDisabled: function() {
        return !this.footnotesEnabled;
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
