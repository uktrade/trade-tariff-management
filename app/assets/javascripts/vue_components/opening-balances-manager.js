Vue.component("opening-balances-manager", {
  template: "#opening-balances-manager-template",
  props: ["section"],
  computed: {
    single: function() {
      return ["1", "1_repeating"].indexOf(this.section.period) > -1;
    },
    noPerPeriod: function() {
      return this.section.type == "annual" &&
             (
               this.single ||
               ( !this.section.staged && !this.section.criticality_each_period && !this.section.duties_each_period )
             );
    },
    omitCriticality: function() {
      return window.all_settings.quota_is_licensed == "true";
    },
    multipleBalances: function() {
      return !this.singleBalance;
    },
    isCustom: function() {
      return this.section.type == "custom";
    },
    disableCriticality: function() {
      return !this.section.criticality_each_period;
    },
    showCriticality: function() {
      return !this.omitCriticality && (this.section.criticality_each_period || this.section.duties_each_period);
    }
  }
});
