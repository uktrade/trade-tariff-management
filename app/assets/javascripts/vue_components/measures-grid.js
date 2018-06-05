Vue.component("measures-grid", {
  template: "#measures-grid-template",
  props: ["onSelectionChange", "data", "columns"],
  data: function() {
    return {
      sortBy: "measure_sid",
      sortDir: "desc",
      selectedRows: [],
      selectAll: false,
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
  mounted: function() {
    var self = this;

    this.data.forEach(function(m) {
      self.selectedRows.push(m.measure_sid);
    });
  },
  watch: {
    selectAll: function(val) {
      if (this.indirectSelectAll) {
        return;
      }

      if (val) {
        this.selectedRows = this.data.map(function(row) {
          return row.measure_sid;
        });
      } else {
        this.selectedRows = [];
      }
    },
    selectedRows: function() {
      var self = this;

      this.indirectSelectAll = true;
      this.selectAll = this.selectedRows.length === this.data.length;

      setTimeout(function() {
        self.indirectSelectAll = false;
      }, 50);

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
