$(document).ready(function() {
  var form = document.querySelector(".review-bulk-edit-measures");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      return {
        bulkActions: {},
        columns: window.BulkEditing.Measures.Columns,
        actions: []
      };
    },
    mounted: function() {
      var self = this;
    },
    methods: {
      recordTableProcessing: window.BulkEditing.Measures.Processing.recordTableProcessing,
      preprocessRecord: window.BulkEditing.Measures.Processing.preprocessRecord
    }
  });
});
