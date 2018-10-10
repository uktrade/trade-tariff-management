window.BulkRemoveAdditionalCodesActions = {
  getWorkbasketId: function(){
    return window.__workbasket_id;
  },
  removeRecords: function(records){
    var sids = records.map(function(record){
      return record.additional_code_sid;
    });

    return $.ajax({
      url: "/additional_codes/bulks/" + this.getWorkbasketId() + "/bulk_items/remove_items.json",
      data: JSON.stringify(sids),
      type: "POST",
      processData: false,
      contentType: "application/json"
    });
  },
  removeAllRecordsInWorkbasket: function(){
    return $.ajax({
      url: "/additional_codes/bulks/" + this.getWorkbasketId(),
      type: "DELETE",
      processData: false,
      contentType: "application/json"
    });
  }
};
