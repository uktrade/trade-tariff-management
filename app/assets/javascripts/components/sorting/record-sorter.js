function RecordSorter(options) {
  this.sortBy = options.sortBy;
  this.type = options.type;
}

RecordSorter.prototype.getSortingFunction = function () {
  var type = this.type;
  var sortBy = this.sortBy;

  switch (type) {
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
  };
}
