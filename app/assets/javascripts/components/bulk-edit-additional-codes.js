//= require ./duty-expression-formatter
//= require ./measure-condition-formatter
//= require ./url-parser
//= require ./db

$(document).ready(function() {
  var form = document.querySelector(".bulk-edit-additional-codes");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        selectedRecords: [],
        showTooltips: true,
        overloaded: false,
        columns: [
          {enabled: true, title: "Type", field: "type_id", sortable: true, type: "string" },
          {enabled: true, title: "Code", field: "additional_code", sortable: true, type: "string" },
          {enabled: true, title: "Description", field: "description", sortable: true, type: "string", changeProp: "description" },
          {enabled: true, title: "Valid from", field: "validity_start_date", sortable: true, type: "date", changeProp: "validity_start_date" },
          {enabled: true, title: "Valid to", field: "validity_end_date", sortable: true, type: "date", changeProp: "validity_end_date" },
          {enabled: true, title: "Last updated", field: "last_updated", sortable: true, type: "string" },
          {enabled: true, title: "Status", field: "status", sortable: true, type: "string", changeProp: "status" }
        ],
        actions: [
          { value: 'toggle_unselected', label: 'Hide/Show unselected items' },
          { value: 'change_description', label: 'Change description' },
          { value: 'change_validity_period', label: 'Change validity period...' },
          { value: 'delete', label: 'Delete...' },
          { value: 'remove_from_group', label: 'Remove from workbasket...' },
        ],
        currentPage: 1,
        records: [],
        changingDescription: false,
        deleting: false,
        removingFromGroup: false,
        changingValidityPeriod: false,
        isLoading: true,
        selectedAllRecords: true,
        pagination: {
          total_count: window.__pagination_metadata.total_count,
          page: window.__pagination_metadata.page,
          per_page: window.__pagination_metadata.per_page,
          pages: Math.ceil(window.__pagination_metadata.total_count / window.__pagination_metadata.per_page)
        },
        sortBy: "type_id",
        sortDir: "desc"
      };

      var query = parseQueryString(window.location.search.substring(1));

      data.search_code = query.search_code;

      return data;
    },
    mounted: function() {
      var self = this;

      history.pushState(null, null, location.href);
      window.onpopstate = function () {
        history.go(1);
      };

      DB.getAdditionalCodesBulk(self.search_code, function(row) {
        if (row === undefined) {
          self.loadRecords(1, self.loadNextPage.bind(self));
        } else {
          self.records = row.payload.map(function(additional_code) {
            if (!additional_code.changes) {
              additional_code.changes = [];
            }

            self.selectedRecords.push(additional_code.additional_code_sid);

            return additional_code;
          });

          self.isLoading = false;
        }

        self.selectedAllRecords = true;
      });
    },
    computed: {
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
        var offset = (this.currentPage - 1) * this.pagination.per_page;

        return this.visibleRecords.slice(offset, offset + this.pagination.per_page);
      },
      visibleCount: function() {
        return this.visibleRecords.length;
      },
      selectedRecordObjects: function() {
        var selectedSids = this.selectedRecords;

        return this.records.filter(function(record) {
          return selectedSids.indexOf(record.additional_code_sid) > -1;
        });
      },
      recordsForTable: function() {
        return this.records.map(function(record) {
          record.validity_end_date = record.validity_end_date || "-";
          record.description = record.description || "-";
          record.status = record.status || "-";

          return record;
        });
      }
    },
    methods: {
      addOriginExclusion: function() {
        this.origin_exclusions.push({ value: '' });
      },
      onItemSelected: function(sid) {
        this.selectedRecords.push(sid);
      },
      onItemDeselected: function(sid) {
        var index = this.selectedRecords.indexOf(sid);

        if (index === -1) {
          return;
        }

        this.selectedRecords.splice(index, 1);
      },
      toggleUnselected: function() {
        var selected = this.selectedRecords;

        this.records.forEach(function(record) {
          if (selected.indexOf(record.additional_code_sid) === -1) {
            record.visible = !record.visible;
          }
        });
      },

      triggerAction: function(val) {

        switch(val) {
          case 'toggle_unselected':
            this.toggleUnselected();
            break;
          case 'change_description':
            this.changingDescription = true;
            break;
          case 'change_validity_period':
            this.changingValidityPeriod = true;
            break;
          case 'remove_from_group':
            this.removingFromGroup = true;
            break;
          case 'delete':
            this.deleting = true;
            break;
        }
      },
      closeAllPopups: function() {
        this.changingValidityPeriod = false;
        this.changingDescription = false;
        this.removingFromGroup = false;
        this.deleting = false;
      },
      loadRecords: function(page, callback) {
        var self = this;

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

            self.selectedRecords.push(record.additional_code_sid);

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

        DB.insertOrReplaceAdditionalCodesBulk(this.search_code, this.records);
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
        BulkEditAdditionalCodesSaveActions.toogleSaveSpinner();

        window.__sb_collection =  this.records;
        window.__sb_total_count = window.__sb_collection.length;
        window.__sb_per_page = window.__pagination_metadata["per_page"];
        window.__sb_total_pages = Math.ceil(window.__sb_total_count / window.__sb_per_page);
        window.__sb_current_batch = 1;

        BulkEditAdditionalCodesSaveActions.sendSaveRequest(mode);
      },
      recordsUpdated: function() {
        DB.insertOrReplaceAdditionalCodesBulk(this.search_code, this.records);
      },
      recordsDeleted: function(deletedRecords){
        var self = this;
        deletedRecords.forEach(function(deletedRecord){
          var measureInTable = self.recordsForTable.find(function(msr){
            return msr.additional_code_sid == deletedRecord.additional_code_sid;
          });
          if (measureInTable) {
            measureInTable.deleted = true;
          }
        });
        this.selectedRecords = [];
        this.recordsUpdated();
      },
      selectAllHasChanged: function(value) {
        this.selectedAllMeasures = value;

        if (value) {
          this.selectedRecords = this.visibleMeasures.map(function(m) {
            return m.additional_code_sid;
          });
        } else {
          this.selectedRecords.splice(0, this.selectedRecords.length);
        }
      },
      recordsRemoved: function(removedRecords) {
        var self = this;
        removedRecords.forEach(function(record) {
          var index = self.records.indexOf(record);
          self.records.splice(index, 1);

          index = self.selectedRecords.indexOf(record.additional_code_sid);
          if (index != -1) {
            self.selectedRecords.splice(index, 1);
          }
        });
        this.recordsUpdated();
      },
      allRecordsRemoved: function() {
        DB.destroyAdditionalCodesBulk(this.search_code);
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

        switch (column.type) {
          case "number":
            return function(a, b) {
              return parseInt(a[sortBy], 10) - parseInt(b[sortBy], 10);
            };
          case "string":
            return function(a, b) {
              a = a[sortBy];
              b = b[sortBy];

            	if (a == null || a == "-") {
            		return -1;
            	}

            	if (b == null || b == "-") {
            		return 1;
            	}

              return ('' + a).localeCompare(b);
            };
          case "date":
            return function(a, b) {
              a = a[sortBy];
              b = b[sortBy];

            	if (a == null || a == "-") {
            		return -1;
            	}

            	if (b == null || b == "-") {
            		return 1;
            	}

              return moment(a, "DD MMM YYYY", true).diff(moment(b, "DD MMM YYYY", true), "days");
            };
          case "comma_string":
            return function(a, b) {
              a = a[sortBy]
              b = b[sortBy]

            	if (a == null || a == "-") {
            		return -1;
            	}

            	if (b == null || b == "-") {
            		return 1;
            	}

              var as = a.split(",").length;
              var bs = b.split(",").length;

              if (as < bs) {
                return -1;
              } else if (as > bs) {
                return 1;
              }

              return ('' + a.attr).localeCompare(b.attr);
            };
          case "duties":
            return function(a, b) {
              a = a[sortBy]
              b = b[sortBy]

              return parseFloat(a) - parseFloat(b);
            };
        }
      }
    }
  });
});
