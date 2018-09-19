Vue.component('date-select', {
  template: "#date-select-template",
  props: ["value", "disabled", "min", "max"],
  data: function() {
    return {
      vproxy: this.value
    }
  },
  mounted: function() {
    var self = this;

    this.pikaday = new Pikaday({
      field: $(this.$el)[0],
      format: "DD/MM/YYYY",
      blurFieldOnSelect: true
    });

    this.applyMinMax();

    $(this.$el).on("change", function() {
      self.vproxy = $(self.$el).val();
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
    }
  },
  watch: {
    vproxy: function() {
      this.$emit("update:value", this.vproxy);
    },
    min: function() {
      this.applyMinMax();
    },
    max: function() {
      this.applyMinMax();
    }
  }
});
