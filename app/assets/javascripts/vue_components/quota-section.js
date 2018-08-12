Vue.component("quota-section", {
  template: "#quota-section-template",
  data: function() {
    return {
      section_types: [
        { id: "annual", label: "Annual" },
        { id: "bi_annual", label: "Bi-annual" },
        { id: "quarterly", label: "Quarterly" },
        { id: "monthly", label: "Monthly" },
        { id: "custom", label: "Custom" }
      ],
      periods: [
        { id: "1_repeating", label: "1 year repeating"},
        { id: "1", label: "1 year" },
        { id: "2", label: "2 years" },
        { id: "3", label: "3 years" },
        { id: "4", label: "4 years" },
        { id: "5", label: "5 years" }
      ],
    };
  },
  props: ["section", "index"],
  methods: {
    emptyDutyExpression: function() {
      return clone({
        duty_expression_id: "01A",
        amount: null,
        measurement_unit_code: null,
        measurement_unit_qualifier_code: null
      });
    },
    resetOpeningBalances: function() {
      var newOpeningBalances = [];

      this.section.duty_expressions.splice(0, 100);

      if (this.section.type == "annual") {

        if (!this.section.duties_each_period) {
          this.section.duty_expressions.push(this.emptyDutyExpression());
        }

        if (this.section.period == "1" || this.section.period == "1_repeating") {
          newOpeningBalances.push({
            balance: "",
            critical: false,
            criticality_threshold: 90,
            duty_expressions: []
          });
        } else {
          var years = parseInt(this.section.period, 10);

          for (var i = 1; i <= years; i++) {
            var balance = {
              balance: "",
              critical: false,
              criticality_threshold: 90,
              duty_expressions: []
            };

            balance.duty_expressions.push(this.emptyDutyExpression());

            newOpeningBalances.push(balance);
          }
        }
      }

      this.section.opening_balances = newOpeningBalances;
    }
  },
  computed: {
    disableStaged: function() {
      return ["1", "1_repeating"].indexOf(this.section.period) > -1;
    },
    disableCriticality: function() {
      return ["1", "1_repeating"].indexOf(this.section.period) > -1;
    },
    disableDuties: function() {
      return ["1", "1_repeating"].indexOf(this.section.period) > -1;
    },
    omitCriticality: function() {
      return window.all_settings.quota_is_licensed == "true";
    }
  },
  watch: {
    "disableCriticality": function(newVal, oldVal) {
      if (!oldVal && newVal) {
        this.section.staged = false;
        this.section.criticality_each_period = false;
        this.section.duties_each_period = false;
      }
    },
    "section.type": function(newVal, oldVal) {
      if (newVal && newVal != oldVal) {
        this.resetOpeningBalances();
      }
    },
    "section.period": function() {
      this.resetOpeningBalances();
    }
  }
});
