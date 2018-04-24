Vue.component('quota-period', {
  template: "#quota-period-template",
  props: ["quotaPeriod", "index"],
  data: function() {
    return {
      quotaOptions: [
        { value: "annual", label: "Annual" },
        { value: "bi_annual", label: "Bi-Annual" },
        { value: "quarterly", label: "Quarterly" },
        { value: "monthly", label: "Monthly" },
        { value: "custom", label: "Custom" }
      ]
    }
  },
  computed: {
    isAnnual: function() {
      return this.quotaPeriod.type === "annual";
    },
    isQuarterly: function() {
      return this.quotaPeriod.type === "quarterly";
    },
    isBiAnnual: function() {
      return this.quotaPeriod.type === "bi_annual";
    },
    isMonthly: function() {
      return this.quotaPeriod.type === "monthly";
    },
    isCustom: function() {
      return this.quotaPeriod.type === "custom";
    },
    isAnnualOrCustom: function() {
      return this.isCustom || this.isAnnual;
    },
    isFirst: function() {
      return this.index === 0;
    }
  }
});
