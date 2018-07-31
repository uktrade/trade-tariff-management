Vue.component("delete-measures-popup", {
  template: "#delete-measures-popup-template",
  props: [
    "measures",
    "onClose",
    "open"
  ],
  data: function() {
    return {
      measuresSentToCDSCount: 0,
      measuresNotSentToCDSCount: 0
    }
  },
  mounted: function() {
    this.measuresSentToCDSCount = this.measures.filter(function(measure){
      return measure.sent_to_cds;
    }).length;
    this.measuresNotSentToCDSCount = this.measures.filter(function(measure){
      return !measure.sent_to_cds;
    }).length;
  },
  methods: {
    triggerClose: function(){
      this.onClose();
    },
    confirmDelete: function(){
      this.measures.forEach(function(measure){
        measure.deleted = true;
      });
      this.$emit("measures-deleted", this.measures);
      this.onClose();
    }
  }
});
