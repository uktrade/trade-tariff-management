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
  data: function(){
    return {
      removingMeasures: false,
      submissionErrors: null
    };
  },
  methods: {
    triggerClose: function(){
      this.onClose();
    },
    confirmRemove: function(){
      var jqxhr,
          self = this;

      this.removingMeasures = true;

      if (this.selectedAllMeasures) {
        jqxhr = BulkRemoveMeasuresActions.removeAllItemsInWorkbasket();
        jqxhr.done(function(){
          self.allMeasuresRemovedCb();
          $(".js-bulk-edit-of-measures-exit-to-search")[0].click(); // click exit
        });
      } else {
        jqxhr = BulkRemoveMeasuresActions.removeItems(this.measures);
        jqxhr.done(function(){
          self.measuresRemovedCb(self.measures);
          self.triggerClose();
        });
      }

      jqxhr.fail(function(){
        self.submissionErrors = "Something went wrong. Please try again.";
      });
      jqxhr.always(function(){
        self.removingMeasures = false;
      });
    }
  }
});
