Vue.component("remove-additional-codes-popup", {
  template: "#remove-additional-codes-popup-template",
  props: [
    "records",
    "onClose",
    "open",
    "selectedAllRecords",
    "recordsRemovedCb",
    "allRecordsRemovedCb"
  ],
  data: function(){
    return {
      removingRecords: false,
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

      this.removingRecords = true;

      if (this.selectedAllRecords) {
        jqxhr = BulkRemoveAdditionalCodesActions.removeAllRecordsInWorkbasket();
        jqxhr.done(function(){
          self.allRecordsRemovedCb();
          $(".js-bulk-edit-of-additional-codes-exit")[0].click(); // click exit
        });
      } else {
        jqxhr = BulkRemoveAdditionalCodesActions.removeRecords(this.records);
        jqxhr.done(function(){
          self.recordsRemovedCb(self.records);
          self.triggerClose();
        });
      }

      jqxhr.fail(function(){
        self.submissionErrors = "Something went wrong. Please try again.";
      });
      jqxhr.always(function(){
        self.removingRecords = false;
      });
    }
  }
});
