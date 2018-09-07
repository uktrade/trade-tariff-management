Vue.component("measures-grid", {
  template: "#measures-grid-template",
  props: [
    "onSelectionChange",
    "onItemSelected",
    "onItemDeselected",
    "onSelectAllChanged",
    "data",
    "columns",
    "selectedRows",
    "clientSorting",
    "sortByChanged",
    "sortDirChanged",
    "selectionType",
    "selectAllHasChanged",
    "clientSelection",
    "disableScroller"
  ],
  data: function() {
    var self = this;

    var selectAll = this.selectionType == 'all';
    var checked = {};

    this.data.forEach(function(measure) {
      checked[measure.measure_sid] = (self.selectionType == 'all' && self.selectedRows.indexOf(measure.measure_sid) === -1) ||
                                     (self.selectionType == 'none' && self.selectedRows.indexOf(measure.measure_sid) > -1);
    });

    if (this.clientSelection === true) {
      selectAll = this.data.filter(function(row) {
        return self.selectedRows.indexOf(row.measure_sid) === -1;
      }).length === 0;
    }

    return {
      sortBy: "measure_sid",
      sortDir: "desc",
      selectAll: selectAll,
      firstLoad: true,
      indirectSelectAll: false,
      checked: checked
    };
  },
  methods: {
    selectSorting: function(column) {
      var f = column.field;

      if (f == this.sortBy) {
        this.sortDir = this.sortDir === "asc" ? "desc" : "asc";
      } else {
        this.sortDir = "desc";
        this.sortBy = f;
      }
    },
    sendCheckedTrigger: function(event) {
      var self = this;

      this.indirectSelectAll = true;

      setTimeout(function() {
        self.indirectSelectAll = false;
      }, 500);

      if (event.target.checked) {
        this.onItemSelected(parseInt(event.target.value, 10));
        window.requestAnimationFrame(function() {
          self.checked[event.target.value] = true;
        });
      } else {
        this.onItemDeselected(parseInt(event.target.value, 10));
        window.requestAnimationFrame(function() {
          self.checked[event.target.value] = false;
        });
      }
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
            return a - b;
          };
        case "date":
          return function(a, b) {
            return a - b;
          }
      }
    },
    rebuildChecked: function() {
      var self = this;
      this.data.forEach(function(measure) {
        self.checked[measure.measure_sid] = (self.selectionType == 'all' && self.selectedRows.indexOf(measure.measure_sid) === -1) ||
                                       (self.selectionType == 'none' && self.selectedRows.indexOf(measure.measure_sid) > -1);
      });
    }
  },
  computed: {
    enabledColumns: function() {
      return this.columns.filter(function(c) {
        return c.enabled;
      });
    },
    sorted: function() {
      if (!this.clientSorting) {
        return this.data;
      }

      var sortDir = this.sortDir;
      var sortFunc = this.getSortingFunc();
      var result = this.data.slice().sort(sortFunc);

      if (sortDir === "asc") {
        return result;
      }

      return result.reverse();
    }
  },
  watch: {
    sortDir: function(val) {
      if (this.sortDirChanged) {
        this.sortDirChanged(val);
      }
    },
    sortBy: function(val) {
      if (this.sortByChanged) {
        this.sortByChanged(val);
      }
    },
    selectAll: function(val) {
      var self = this;

      if (this.indirectSelectAll) {
        return;
      }

      if (this.selectAllHasChanged) {
        this.selectAllHasChanged(val);
      }

      if (this.onSelectAllChanged) {
        this.onSelectAllChanged(val);

        if(this.clientSelection !== true) {
          requestAnimationFrame(function() {
            self.rebuildChecked();
          });

          return;
        }
      }

      if (val) {
        this.data.map(function(row) {
          if (self.selectedRows.indexOf(row.measure_sid) === -1) {
            self.onItemSelected(row.measure_sid);
            self.checked[row.measure_sid] = true;
          }
        });
      } else {
        this.data.map(function(row) {
          self.onItemDeselected(row.measure_sid);
          self.checked[row.measure_sid] = false;
        });
      }
    },
    selectedRows: function(newVal, oldVal) {
      var self = this;

      if (!this.onSelectAllChanged) {
        this.indirectSelectAll = true;

        this.selectAll = this.data.filter(function(row) {
          return self.selectedRows.indexOf(row.measure_sid) === -1;
        }).length === 0;

        setTimeout(function() {
          self.indirectSelectAll = false;
        }, 200);
      }

      if (this.onItemSelected) {
        newVal.forEach(function(m) {
          if (oldVal.indexOf(m) === -1) {
            self.onItemSelected(m);
            self.checked[m] = true;
          }
        });
      }

      if (this.onItemDeselected) {
        oldVal.forEach(function(m) {
          if (newVal.indexOf(m) === -1) {
            self.onItemDeselected(m);
            self.checked[m] = false;
          }
        });
      }
    },
    data: function(val) {
      if (this.clientSelection !== true) {
        return;
      }

      var self = this;

      this.data.forEach(function(measure) {
        self.checked[measure.measure_sid] = (self.selectionType == 'all' && self.selectedRows.indexOf(measure.measure_sid) === -1) ||
                                            (self.selectionType == 'none' && self.selectedRows.indexOf(measure.measure_sid) > -1);
      });
    }
  }
})
