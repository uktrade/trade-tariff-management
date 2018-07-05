Vue.component("remove-measures-popup", {
  template: "#remove-measures-popup-template",
  props: [
    "measures",
    "onClose",
    "open",
    "selectedAllMeasures",
    "measuresRemovedCb",
    "allMeasuresRemovedCb"
  ],
  methods: {
    triggerClose: function(){
      this.onClose();
    },
    confirmRemove: function(){
      var jqxhr,
          self = this;
      if (this.selectedAllMeasures) {
        jqxhr = BulkRemoveMeasuresActions.removeAllMeasuresInWorkbasket();
        jqxhr.always(function(){
          self.allMeasuresRemovedCb();
          $(".js-bulk-edit-of-measures-exit")[0].click(); // click exit
        });
      } else {
        jqxhr = BulkRemoveMeasuresActions.removeMeasures(this.measures);
        jqxhr.always(function(){
          self.measuresRemovedCb(self.measures);
          self.triggerClose();
        });
      }
    }
  }
});
