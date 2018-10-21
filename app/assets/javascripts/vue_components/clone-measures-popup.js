Vue.component("clone-measures-popup", {
  template: "#clone-measures-popup-template",
  props: [
    "records",
    "onClose",
    "open",
    "selectedAllMeasures",
    "measuresRemovedCb",
    "allMeasuresRemovedCb"
  ],
  data: function(){
    return {
      cloning: false,
      selectAll: false,
      excludeCommodityCode: false,
      excludeOrigin: false,
      excludeDuties: false,
      excludeConditions: false,
      excludeFootnotes: false,

      updatingSelectAll: false
    };
  },
  computed: {
    allSame: function() {
      var all = !this.excludeCommodityCode &&
                !this.excludeOrigin &&
                !this.excludeDuties &&
                !this.excludeConditions &&
                !this.excludeFootnotes;

      return all;
    }
  },
  methods: {
    triggerClose: function(){
      this.onClose();
    },
    cloneMeasures: function(){
      this.cloning = true;

      var excludeCommodityCode = this.excludeCommodityCode;
      var excludeOrigin = this.excludeOrigin;
      var excludeDuties = this.excludeDuties;
      var excludeConditions = this.excludeConditions;
      var excludeFootnotes = this.excludeFootnotes;

      var newMeasures = this.records.map(function(measure) {
        var newMeasure = clone(measure);

        newMeasure.row_id = makeBigNumber();
        newMeasure.measure_sid = newMeasure.row_id;
        newMeasure.clone = true;

        if (excludeCommodityCode) {
          newMeasure.goods_nomenclature = null;
        }

        if (excludeOrigin) {
          newMeasure.geographical_area = null;
          newMeasure.excluded_geographical_areas = [];
        }

        if (excludeDuties) {
          newMeasure.measure_components = [];
        }

        if (excludeConditions) {
          newMeasure.measure_conditions = [];
        }

        if (excludeFootnotes) {
          newMeasure.footnotes = [];
        }

        return newMeasure;
      });

      this.$emit("records-cloned", newMeasures);
      this.onClose();
    },
    updateSelectAll: function() {
      var self = this;

      var all = this.excludeCommodityCode &&
                this.excludeOrigin &&
                this.excludeDuties &&
                this.excludeConditions &&
                this.excludeFootnotes;

      this.updatingSelectAll = true;
      this.selectAll = all;

      Vue.nextTick(function() {
        self.updatingSelectAll = false;
      });
    }
  },
  watch: {
    selectAll: function(val) {
      if (this.updatingSelectAll) {
        return;
      }

      this.excludeCommodityCode = val;
      this.excludeOrigin = val;
      this.excludeDuties = val;
      this.excludeConditions = val;
      this.excludeFootnotes = val;
    },
    excludeCommodityCode: function(val) {
      this.updateSelectAll();
    },
    excludeOrigin: function(val) {
      this.updateSelectAll();
    },
    excludeDuties: function(val) {
      this.updateSelectAll();
    },
    excludeConditions: function(val) {
      this.updateSelectAll();
    },
    excludeFootnotes: function(val) {
      this.updateSelectAll();
    },
  }
});
