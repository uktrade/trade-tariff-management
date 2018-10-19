Vue.component("force-delete-measures-popup", {
  template: "#force-delete-measures-popup-template",
  props: [
    "measures",
    "onClose",
    "open"
  ],
  methods: {
    triggerClose: function(){
      this.onClose();
    },
    confirmForceDelete: function(){
      this.measures.forEach(function(measure){
        measure.force_deleted = true;
      });
      this.$emit("measures-force-deleted", this.measures);
      this.onClose();
    }
  }
});
