Vue.component("opening-balances-manager", {
  template: "#opening-balances-manager-template",
  props: ["section"],
  computed: {
    singleBalance: function() {
      return this.section.type == "annual" && ["1", "1_repeating"].indexOf(this.section.period) > -1;
    },
    omitCriticality: function() {
      return window.all_settings.quota_is_licensed == "true";
    }
  }
});
