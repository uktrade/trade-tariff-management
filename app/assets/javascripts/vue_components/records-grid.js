Vue.component("records-grid", {
  template: "#records-grid-template",
  props: [
    "primaryKey",
    "tableClass",
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
    "disableSelection",
    "disableSelectAll",
    "singleSelection",
    "selectedItem"
  ],
  data: function() {
    var self = this;

    var selectAll = this.selectionType == 'all';
    var checked = {};

    this.data.forEach(function(record) {
      var sid = record[self.primaryKey];

      checked[sid] = (self.selectionType == 'all' && self.selectedRows.indexOf(sid) === -1) ||
                     (self.selectionType == 'none' && self.selectedRows.indexOf(sid) > -1);
    });

    if (this.clientSelection === true) {
      selectAll = this.data.filter(function(row) {
        return self.selectedRows.indexOf(row[self.primaryKey]) === -1;
      }).length === 0;
    }

    return {
      sortBy: this.columns[0].field,
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
      this.data.forEach(function(record) {
        var sid = record[self.primaryKey];

        self.checked[sid] = (self.selectionType == 'all' && self.selectedRows.indexOf(sid) === -1) ||
                            (self.selectionType == 'none' && self.selectedRows.indexOf(sid) > -1);
      });
    }
  },
  computed: {
    classes: function() {
      var classes = ['records-table'];

      if (this.tableClass) {
        classes.push(this.tableClass);
      }

      return classes;
    },
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
          if (self.selectedRows.indexOf(row[self.primaryKey]) === -1) {
            self.onItemSelected(row[self.primaryKey]);
            self.checked[row[self.primaryKey]] = true;
          }
        });
      } else {
        this.data.map(function(row) {
          self.onItemDeselected(row[self.primaryKey]);
          self.checked[row[self.primaryKey]] = false;
        });
      }
    },
    selectedRows: function(newVal, oldVal) {
      var self = this;

      if (this.clientSelection) {
        this.indirectSelectAll = true;

        this.selectAll = this.data.filter(function(row) {
          return self.selectedRows.indexOf(row[self.primaryKey] + '') === -1;
        }).length === 0;

        setTimeout(function() {
          self.indirectSelectAll = false;
        }, 200);

        return;
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

      this.data.forEach(function(record) {
        self.checked[record[self.primaryKey]] = (self.selectionType == 'all' && self.selectedRows.indexOf(record[self.primaryKey]) === -1) ||
                                            (self.selectionType == 'none' && self.selectedRows.indexOf(record[self.primaryKey]) > -1);
      });
    }
  }
})
