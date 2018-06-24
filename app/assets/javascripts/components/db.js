window.DB = {
  VERSION: 1,
  connection: null,
  open: function() {
    this.connection = new Dexie("DIT_DATABASE");
    this.connection.version(1).stores({
      measures: "++id, &search_code"
    });
  },
  insertOrReplaceBulk: function(search_code, payload) {
    var self = this;
    var db = this.connection;

    db.transaction("rw", db.measures, function() {
      db.measures.where("search_code").equals(search_code).delete();

      db.measures.add({
        search_code: search_code,
        payload: payload
      });
    });
  },
  getMeasuresBulk: function(search_code, callback) {
    var self = this;
    var db = this.connection;

    db.transaction("rw", db.measures, function() {
      db.measures.where("search_code").equals(search_code).first(callback);
    });
  }
};

DB.open();
