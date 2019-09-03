Vue.component('date-gds', {
  template: "#date-gds-template",
  props: ["label", "hint", "required", "disabled", "value", "error", "min", "max"],
  data: function() {
    return {
      dateString: this.value,
      errorMessage: this.error
    }
  },
  mounted: function() {
    var self = this;

    this.applyMinMax();

    if (this.value) {
      this.generateDateInputValues()
    }

    // input listeners
    $(this.$el).find('#day').on("change", function() {
      self.generateDateString()
    });
    $(this.$el).find('#month').on("change", function() {
      self.generateDateString()
    });
    $(this.$el).find('#year').on("change", function() {
      self.generateDateString()
    });
  },
  methods: {
    applyMinMax: function() {
      if (this.min) {
        var min = moment(this.min, ["DD MMM YYYY", "DD/MM/YYYY"], true);
        this.pikaday.setMinDate(min.isValid() ? min.toDate() : null);
      }

      if (this.max) {
        var max = moment(this.max, ["DD MMM YYYY", "DD/MM/YYYY"], true);
        this.pikaday.setMaxDate(max.isValid() ? max.toDate() : null);
      }
    },
    generateDateString: function () {
      this.dateString = null;

      var d = $(this.$el).find('#day').val();
      var m = $(this.$el).find('#month').val();
      var y = $(this.$el).find('#year').val();

      if (d && m && y) {
        var dateParsed = moment(parseInt(y) + "-" + parseInt(m) + "-" + parseInt(d));
        if (dateParsed.isValid() && !isNaN(parseInt(y))) {
          this.errorMessage = null;
          this.dateString = dateParsed.format("DD/MM/YYYY");
        } else {
          this.errorMessage = "Please enter a valid date";
        }
      }
    },
    generateDateInputValues: function () {
      var dateValue = moment(this.value, 'DD/MM/YYYY');
      $(this.$el).find('#day').val(dateValue.format('DD'));
      $(this.$el).find('#month').val(dateValue.format('MM'));
      $(this.$el).find('#year').val(dateValue.format('YYYY'));
    }
  },
  watch: {
    value: function() {
      this.dateString = this.value;
    },
    dateString: function() {
      this.$emit("update:value", this.dateString);
    },
    error: function() {
      this.errorMessage = this.error;
    },
    min: function() {
      this.applyMinMax();
    },
    max: function() {
      this.applyMinMax();
    }
  },
  destroyed: function() {

  }
});
