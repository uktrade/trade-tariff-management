Vue.component("measures-grid", {
  template: "#measures-grid-template",
  props: ["onSelectionChange", "data", "columns"],
  data: function() {
    return {
      sortBy: "measure_sid",
      sortDir: "desc",
      selectedRows: [],
      selectAll: false
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
      if (val) {
        this.selectedRows = this.data.map(function(row) {
          return row.measure_sid;
        });
      } else {
        this.selectedRows = [];
      }
    },
    selectedRows: function() {
      this.selectAll = this.selectedRows.length === this.data.length;

      if (this.onSelectionChange) {
        try {
          this.onSelectionChange(this.selectedRows);
        } catch (e) {
          console.log(e);
        }
      }
    }
  }
})
