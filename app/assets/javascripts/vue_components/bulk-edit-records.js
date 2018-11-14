//= require ../components/duty-expression-formatter
//= require ../components/measure-condition-formatter
//= require ../components/url-parser
//= require ../components/db
//= require ../components/sorting/record-sorter

Vue.component("bulk-edit-records", {
  template: "#bulk-edit-records-template",
  props: [
    "primaryKey",
    "initialSortKey",
    "bulkActions",
    "thing",
    "columns",
    "actions",
    "recordTableProcessing",
    "preprocessRecord"
  ],
  data: function() {
    var data = {
      selectedRecords: [],
      showTooltips: true,
      overloaded: false,
      currentPage: 1,
      records: [],
      selectedAction: null,
      isLoading: true,
      selectedAllRecords: true,
      pagination: {
        total_count: window.__pagination_metadata.total_count,
        page: window.__pagination_metadata.page,
        per_page: window.__pagination_metadata.per_page,
        pages: Math.ceil(window.__pagination_metadata.total_count / window.__pagination_metadata.per_page)
      },
      sortBy: this.initialSortKey,
      sortDir: "desc"
    };

    var query = parseQueryString(window.location.search.substring(1));

    data.search_code = query.search_code;

    return data;
  },
  mounted: function() {
    var self = this;

    if (this.pagination.total_count === 0) {
      return;
    }

    DB.getBulkRecords(self.search_code, function(row) {
      if (row === undefined) {
        self.loadRecords(1, self.loadNextPage.bind(self));
      } else {
        self.records = row.payload.map(function(record) {
          if (!record.changes) {
            record.changes = [];
          }

          record.errors = [];

          record[self.primaryKey] += '';

          self.selectedRecords.push(record[self.primaryKey]);

          return record;
        });

        self.isLoading = false;
      }

      self.selectedAllRecords = true;
    });

    $(document).on("bulk:validated", function() {
      var columns = self.bulkActions.errorColumns;
      var errors = self.bulkActions.errors;

      self.columns.forEach(function(col) {
        if (columns.indexOf(col.field) > -1 && !col.enabled) {
          col.enabled = true;
        }
      });

      self.records.forEach(function(record) {
        record.errors = errors[record.row_id] || [];
      });
    });
  },
  computed: {
    tableClass: function() {
      var thing = this.thing;

      return thing.toLowerCase().split(" ").join("-");
    },
    noSelectedRecords: function() {
      return this.selectedRecords.length === 0;
    },
    visibleRecords: function() {
      var records = this.recordsForTable.filter(function(record) {
        return record.visible;
      });

      records.sort(this.getSortingFunc());

      if (this.sortDir == "desc") {
        records.reverse();
      }

      return records;
    },

    visibleRecordsPage: function() {
      var offset = (this.currentPage - 1) * 25;

      return this.visibleRecords.slice(offset, offset + 25);
    },
    visibleCount: function() {
      return this.visibleRecords.length;
    },
    selectedRecordObjects: function() {
      var selectedSids = this.selectedRecords;
      var pk = this.primaryKey;

      return this.records.filter(function(record) {
        return selectedSids.indexOf(record[pk] + '') > -1;
      });
    },
    recordsForTable: function() {
      return this.records.map(this.recordTableProcessing.bind(this));
    }
  },
  methods: {
    onItemSelected: function(sid) {
      if (this.selectedRecords.indexOf(sid + '') === -1) {
        this.selectedRecords.push(sid + '');
      }

      this.updateSelectedAll();
    },
    onItemDeselected: function(sid) {
      var index = this.selectedRecords.indexOf(sid + '');

      if (index === -1) {
        return;
      }

      this.selectedRecords.splice(index, 1);
      this.updateSelectedAll();
    },
    toggleUnselected: function() {
      var selected = this.selectedRecords;
      var pk = this.primaryKey;

      this.records.forEach(function(record) {
        if (selected.indexOf(record[pk] + '') === -1) {
          record.visible = !record.visible;
        }
      });
    },

    triggerAction: function(val) {
      if (val == "toggle_unselected") {
        this.toggleUnselected();
      } else {
        this.selectedAction = val;
      }
    },
    closeAllPopups: function() {
      this.selectedAction = false;
    },
    loadRecords: function(page, callback) {
      var self = this;
      var pk = this.primaryKey;

      var url = window.location.href + "&page=" + page;
      var options = {
        type: "GET",
        url: url
      };

      retryAjax(options, 10, 5000, function(data) {
        self.records = self.records.concat(data.collection.map(function(record) {
          record.visible = true;

          if (!record.changes) {
            record.changes = [];
          }

          self.preprocessRecord(record);

          record[pk] += '';

          record.errors = [];

          self.selectedRecords.push(record[pk] + '');

          return record;
        }));

        self.pagination.page = parseInt(data.current_page, 10);
        self.pagination.pages = parseInt(data.total_pages, 10);

        callback();
      }, function() {
        self.overloaded = true;
        setTimeout(function() {
          self.overloaded = false;
          Vue.nextTick(function() {
            self.loadRecords.apply(self, [page, callback]);
          });
        }, 30000);
      });
    },
    loadNextPage: function() {
      var self = this;

      if (this.pagination.page === this.pagination.pages) {
        this.recordsFinishedLoading();

        return;
      }

      this.loadRecords(this.pagination.page + 1, this.loadNextPage.bind(this));
    },
    recordsFinishedLoading: function() {
      this.isLoading = false;

      DB.insertOrReplaceBulk(this.search_code, this.records);
    },
    onPageChange: function(page) {
      this.currentPage = page;

      $("html, body").animate({
        scrollTop: $(this.$el).offset().top
      }, 500);
    },
    saveForCrossCheck: function() {
      window.__save_bulk_edit_mode = "save_group_for_cross_check";
      this.startSavingProcess('save_group_for_cross_check');
    },
    saveProgress: function () {
      window.__save_bulk_edit_mode = "save_progress";
      this.startSavingProcess('save_progress');
    },
    startSavingProcess: function(mode) {
      this.bulkActions.toogleSaveSpinner();

      window.__sb_collection =  this.records;
      window.__sb_total_count = window.__sb_collection.length;
      window.__sb_per_page = window.__pagination_metadata["per_page"];
      window.__sb_total_pages = Math.ceil(window.__sb_total_count / window.__sb_per_page);
      window.__sb_current_batch = 1;

      this.bulkActions.sendSaveRequest(mode);
    },
    recordsUpdated: function() {
      DB.insertOrReplaceBulk(this.search_code, this.records);
    },
    recordsDeleted: function(deletedRecords){
      var self = this;
      var pk = this.primaryKey;

      deletedRecords.forEach(function(deletedRecord){
        var recordInTable = self.recordsForTable.find(function(msr){
          return msr[pk] == deletedRecord[pk];
        });
        if (recordInTable) {
          recordInTable.deleted = true;
        }
      });
      this.selectedRecords = [];
      this.recordsUpdated();
      this.updateSelectedAll();
    },
    selectAllHasChanged: function(value) {
      this.selectedAllMeasures = value;
      var pk = this.primaryKey;

      if (value) {
        this.selectedRecords = this.records.map(function(m) {
          return m[pk] + '';
        });
      } else {
        this.selectedRecords.splice(0, this.selectedRecords.length);
      }
    },
    recordsRemoved: function(removedRecords) {
      var self = this;
      var pk = this.primaryKey;

      removedRecords.forEach(function(record) {
        var index = self.records.indexOf(record);
        self.records.splice(index, 1);

        index = self.selectedRecords.indexOf(record[pk] + '');
        if (index != -1) {
          self.selectedRecords.splice(index, 1);
        }
      });
      this.recordsUpdated();
      this.updateSelectedAll();
    },
    updateSelectedAll: function() {
      var self = this;
      var pk = this.primaryKey;

      this.selectedAllRecords = this.records.filter(function(record) {
        return self.selectedRecords.indexOf(record[pk] + '') > -1;
      }).length === this.records.length;
    },
    allRecordsRemoved: function() {
      DB.destroyBulk(this.search_code);
    },
    onSortByChange: function(val) {
      this.sortBy = val;
    },
    onSortDirChanged: function(val) {
      this.sortDir = val;
    },
    findColumn: function(field) {
      for (var k in this.columns) {
        var o = this.columns[k];

        if (o.field == field) {
          return o;
        }
      }
    },
    getSortingFunc: function() {
      var column = this.findColumn(this.sortBy);
      var sortBy = this.sortBy;

      var sorter = new RecordSorter(sortBy);

      return sorter.getSortingFunction(column.type);
    },
    recordsCloned: function(newRecords) {
      for (var i = 0; i < newRecords.length; i++) {
        this.records.push(newRecords[i]);
      }

      this.recordsUpdated();
      this.updateSelectedAll();
    }
  }
});
