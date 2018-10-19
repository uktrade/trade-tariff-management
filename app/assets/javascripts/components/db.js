window.DB = {
  connection: null,
  open: function() {
    this.connection = new Dexie("DIT_DATABASE_V2");
    this.connection.version(1).stores({
      bulk_items: "++id, &search_code",
    });
  },
  insertOrReplaceBulk: function(search_code, payload) {
    var self = this;
    var db = this.connection;

    db.transaction("rw", db.bulk_items, function() {
      self.destroyBulk(search_code);

      db.bulk_items.add({
        search_code: search_code,
        payload: payload
      });
    });
  },
  getBulkRecords: function(search_code, callback) {
    var db = this.connection;

    db.transaction("rw", db.bulk_items, function() {
      db.bulk_items.where("search_code").equals(search_code).first(callback);
    });
  },
  destroyBulk: function(search_code) {
    var db = this.connection;

    db.transaction("rw", db.bulk_items, function() {
      db.bulk_items.where("search_code").equals(search_code).delete();
    });
  }
};

DB.open();
