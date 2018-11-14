$(document).ready(function() {
  var form = document.querySelector(".bulk-edit-quota-measures");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      return {
        bulkActions: BulkEditOfQuotaMeasuresSaveActions,
        columns: window.BulkEditing.Measures.Columns,
        actions: [
          window.BulkEditing.Measures.Actions.unselected,
          window.BulkEditing.Measures.Actions.regulation,
          window.BulkEditing.Measures.Actions.dates,
          window.BulkEditing.Measures.Actions.origin,
          window.BulkEditing.Measures.Actions.duties,
          window.BulkEditing.Measures.Actions.conditions,
          window.BulkEditing.Measures.Actions.footnotes,
          window.BulkEditing.Measures.Actions.clone,
          window.BulkEditing.Measures.Actions.delete,
          // window.BulkEditing.Measures.Actions.forcedelete,
          // window.BulkEditing.Measures.Actions.restore
        ]
      };
    },
    mounted: function() {
      var self = this;

      lockBackHistory();
    },
    methods: {
      recordTableProcessing: window.BulkEditing.Measures.Processing.recordTableProcessing,
      preprocessRecord: window.BulkEditing.Measures.Processing.preprocessRecord
    }
  });
});
