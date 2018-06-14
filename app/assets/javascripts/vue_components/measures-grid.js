Vue.component("measures-grid", {
  template: "#measures-grid-template",
  props: ["onSelectionChange", "onItemSelected", "onItemDeselected", "data", "columns", "selectedRows"],
  data: function() {
    var selectAll = this.data.map(function(m) {
      return self.selectedRows.indexOf(m.measure_sid) === -1;
    }).filter(function(b) {
      return b;
    }).length === 0;

    return {
      sortBy: "measure_sid",
      sortDir: "desc",
      selectAll: selectAll,
      firstLoad: true,
      indirectSelectAll: false
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
      if (event.target.checked) {
        this.onItemSelected(parseInt(event.target.value, 10));
      } else {
        this.onItemDeselected(parseInt(event.target.value, 10));
      }
    }
  },
  computed: {
    enabledColumns: function() {
      return this.columns.filter(function(c) {
        return c.enabled;
      });
    },
    sorted: function() {
      var sortBy = this.sortBy;
      var sortDir = this.sortDir;

      var result = this.data.sort(function(a, b) {
        return a[sortBy] - b[sortDir];
      })

      if (sortDir === "asc") {
        return result;
      }

      return result;
    }
  },
  watch: {
    selectAll: function(val) {
      var self = this;

      if (this.indirectSelectAll) {
        return;
      }

      if (val) {
        this.data.map(function(row) {
          self.onItemSelected(row.measure_sid);
        });
      } else {
        this.data.map(function(row) {
          self.onItemDeselected(row.measure_sid);
        });
      }
    },
    selectedRows: function(newVal, oldVal) {
      var self = this;

      this.indirectSelectAll = true;
      this.selectAll = this.data.map(function(m) {
        return self.selectedRows.indexOf(m.measure_sid) === -1;
      }).filter(function(b) {
        return b;
      }).length === 0;

      setTimeout(function() {
        self.indirectSelectAll = false;
      }, 50);

      if (this.onItemSelected) {
        newVal.forEach(function(m) {
          if (oldVal.indexOf(m) === -1) {
            self.onItemSelected(m);
          }
        });
      }

      if (this.onItemDeselected) {
        oldVal.forEach(function(m) {
          if (newVal.indexOf(m) === -1) {
            self.onItemDeselected(m);
          }
        });
      }
    }
  }
})
