$(document).ready(function() {
  var form = document.querySelector(".bulk-edit-additional-codes");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      return {
        bulkActions: BulkEditAdditionalCodesSaveActions,
        columns: [
          {enabled: true, title: "Type", field: "type_id", sortable: true, type: "string" },
          {enabled: true, title: "Code", field: "additional_code", sortable: true, type: "string" },
          {enabled: true, title: "Description", field: "description", sortable: true, type: "string", changeProp: "description" },
          {enabled: true, title: "Start date", field: "validity_start_date", sortable: true, type: "date", changeProp: "validity_start_date" },
          {enabled: true, title: "End date", field: "validity_end_date", sortable: true, type: "date", changeProp: "validity_end_date" },
          {enabled: true, title: "Status", field: "status", sortable: true, type: "string", changeProp: "status" }
        ],
        actions: [
          { value: 'toggle_unselected', label: 'Hide/Show unselected items' },
          { value: 'change_description', label: 'Change description' },
          { value: 'change_validity_period', label: 'Change validity period...' },
          { value: 'delete', label: 'Delete...' },
          { value: 'remove_from_group', label: 'Remove from workbasket...' },
        ]
      };
    },
    mounted: function() {
      var self = this;

      history.pushState(null, null, location.href);
      window.onpopstate = function () {
        history.go(1);
      };
    },
    methods: {
      recordTableProcessing: function(record) {
        return record;
      },
      preprocessRecord: function(record) {
        record.additional_code_sid = record.additional_code_sid + '';

        record.row_id = makeBigNumber();

        return record;
      }
    }
  });
});
