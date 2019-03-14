//= require ../components/duty-expression-formatter
//= require ../components/measure-condition-formatter
//= require ../components/url-parser
//= require ../components/db
//= require ../components/sorting/record-sorter

Vue.component("review-bulk-edit-records", {
  template: "#review-bulk-edit-records-template",
  props: [
    "primaryKey",
    "initialSortKey",
    "bulkActions",
    "thing",
    "columns",
    "actions",
    "recordTableProcessing",
    "preprocessRecord",
    "workbasket_id"
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

    if (!data.search_code) {
      data.search_code = "NO_SEARCH";
    }

    return data;
  },
  mounted: function() {
    var self = this;

    if (this.pagination.total_count === 0) {
      return;
    }

    self.loadRecords(1, self.loadNextPage.bind(self));
    self.selectedAllRecords = true;

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
    loadRecords: function(page, callback) {
      var self = this;
      var pk = this.primaryKey;

      var url = '/bulk_edit_of_measures/' + self.workbasket_id + '.json'
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
        this.isLoading = false;

        return;
      }

      this.loadRecords(this.pagination.page + 1, this.loadNextPage.bind(this));
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
    }
  }
});
