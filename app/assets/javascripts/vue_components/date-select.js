Vue.component('date-select', {
  template: "#date-select-template",
  props: ["value", "disabled", "minYear"],
  data: function() {
    var data = {
      day: "",
      month: "",
      year: ""
    };

    var valueMoment = moment(this.value, "DD/MM/YYYY", true);

    if (valueMoment.isValid()) {
      data.day = valueMoment.format("DD");
      data.month = valueMoment.format("MM");
      data.year = valueMoment.year();
    } else {
      this.year = moment().year();
    }

    return data;
  },
  computed: {
    days: function() {
      var days = [];
      for (var i = 1; i <= 31; i++) {
        var v = this.leftPad(i + "", 2, "0");
         days.push({ value: v, label: v });
      }
       return days;
    },
    months: function() {
      return [
        { value: "01", label: "January" },
        { value: "02", label: "February" },
        { value: "03", label: "March" },
        { value: "04", label: "April" },
        { value: "05", label: "May" },
        { value: "06", label: "June" },
        { value: "07", label: "July" },
        { value: "08", label: "August" },
        { value: "09", label: "September" },
        { value: "10", label: "October" },
        { value: "11", label: "November" },
        { value: "12", label: "December" }
      ];
    },
    years: function() {
      var minYear = this.minYear || (new Date()).getFullYear() - 100;
      var maxYear = (new Date()).getFullYear() + 100;
      var years = [];
       for (var i = minYear; i <= maxYear; i++) {
        years.push({ value: i, label: i });
      }

      return years;
    }
  },
  methods: {
    leftPad: function(val, length, pad) {
      while (val.length < length) {
        val = pad + val;
      }

      return val;
    },
    updateValue: function() {
      if (this.day && this.month && this.year) {
        this.$emit("update:value", this.day + "/" + this.month + "/" + this.year);
      }
    }
  },
  watch: {
    year: function() {
      this.updateValue();
    },
    day: function() {
      this.updateValue();
    },
    month: function() {
      this.updateValue();
    }
  }
});
