Vue.component('date-gds', {
  template: "#date-gds-template",
  props: ["label", "hint", "required", "disabled", "value", "error", "input_name"],
  data: function() {
    return {
      dateString: this.value,
      errorMessage: this.error,
      inputName: this.input_name
    }
  },
  mounted: function() {
    var self = this;

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
    }
  },
  destroyed: function() {

  }
});
