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
        changingStatus: false
      };
    },
    mounted: function() {
      var self = this;

      var data = {
        measure_sids: window.__measure_sids
      };

      $.get("/measures/bulks/info", data, function(data) {
        self.measures = data.map(function(measure) {
          measure.visible = true;

          return measure;
        });
      });
    },
    computed: {
      noSelectedMeasures: function() {
        return this.selectedMeasures.length === 0;
      },
      visibleMeasures: function() {
        return this.measures.filter(function(measure) {
          return measure.visible;
        });
      },
      selectedMeasureObjects: function() {
        var selectedSids = this.selectedMeasures;

        return this.measures.filter(function(measure) {
          return selectedSids.indexOf(measure.measure_sid) > -1;
        });
      }
    },
    methods: {
      addOriginExclusion: function() {
        this.origin_exclusions.push({ value: '' });
      },
      onMeasuresSelected: function(sids) {
        this.selectedMeasures = sids;
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
      }
    }
  });
});
