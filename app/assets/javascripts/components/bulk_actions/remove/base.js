window.BulkActionsRemoveBase = {
  primary_key: '',
  thing: '',
  getWorkbasketId: function(){
    return window.__workbasket_id;
  },
  removeItems: function(items){
    var pk = this.primary_key;
    var thing = this.thing;

    var sids = items.map(function(item){
      return item[pk];
    });

    return $.ajax({
      url: "/" + thing + "/bulks/" + this.getWorkbasketId() + "/bulk_items/remove_items.json",
      data: JSON.stringify(sids),
      type: "POST",
      processData: false,
      contentType: "application/json"
    });
  },
  removeAllItemsInWorkbasket: function(){
    var thing = this.thing;

    return $.ajax({
      url: "/" + thing + "/bulks/" + this.getWorkbasketId(),
      type: "DELETE",
      processData: false,
      contentType: "application/json"
    });
  }
};
