Vue.component("delete-measures-popup", {
  template: "#delete-measures-popup-template",
  props: [
    "measures",
    "onClose",
    "open",
    "selectedAllMeasures",
    "measuresDeletedCb",
    "allMeasuresDeletedCb"
  ],
  methods: {
    triggerClose: function(){
      this.onClose();
    },
    confirmDelete: function(){
      var jqxhr,
          self = this;
      if (this.selectedAllMeasures) {
        jqxhr = BulkDeleteMeasuresActions.deleteAllMeasuresInWorkbasket();
        jqxhr.always(function(){
          self.allMeasuresDeletedCb();
          $(".js-bulk-edit-of-measures-exit")[0].click(); // click exit
        });
      } else {
        jqxhr = BulkDeleteMeasuresActions.deleteMeasures(this.measures);
        jqxhr.always(function(){
          self.measuresDeletedCb(self.measures);
          self.triggerClose();
        });
      }
    }
  }
});
