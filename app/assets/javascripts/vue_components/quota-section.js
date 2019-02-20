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
        // { id: "1_repeating", label: "1 year repeating"},
        { id: "1", label: "1 year" },
        { id: "2", label: "2 years" },
        { id: "3", label: "3 years" },
        { id: "4", label: "4 years" },
        { id: "5", label: "5 years" }
      ],
      monetary_units: [
        { id: "EUR", label: "EUROs"}
      ]
    };
  },
  props: ["section", "index"],
  methods: {
    updateBalances: function(balances) {
      var self = this;

      if (!this.section.parent_quota.balances) {
        this.section.parent_quota.balances = [];
      }

      this.section.parent_quota.balances.splice(0, 999);

      balances.forEach(function(b, i) {
        Vue.set(self.section.parent_quota.balances, i, b);
      });
    },
    emptyDutyExpression: function() {
      return clone({
        duty_expression_id: "01A",
        amount: null,
        measurement_unit_code: null,
        measurement_unit_qualifier_code: null
      });
    },
    balanceForType: function(type) {
      if (type == "annual") {
        return "";
      } else if (type == "bi_annual") {
        return {
          semester1: "",
          semester2: ""
        };
      } else if (type == "quarterly") {
        return {
          quarter1: "",
          quarter2: "",
          quarter3: "",
          quarter4: ""
        };
      } else if (type == "monthly") {
        return {
          month1: "",
          month2: "",
          month3: "",
          month4: "",
          month5: "",
          month6: "",
          month7: "",
          month8: "",
          month9: "",
          month10: "",
          month11: "",
          month12: ""
        };
      } else if (type == "custom") {

      }
    },
    blankOpeningBalance: function(type) {
      var self = this;

      var ks = {
        bi_annual: ["semester1", "semester2"],
        quarterly: ["quarter1", "quarter2", "quarter3", "quarter4"],
        monthly: ["month1", "month2", "month3", "month4", "month5", "month6", "month7", "month8", "month9", "month10", "month11", "month12"]
      };

      if (type == "annual") {
        return {
          balance: "",
          critical: false,
          criticality_threshold: 90,
          duty_expressions: [this.emptyDutyExpression()]
        };
      } else if (type == "custom") {

      } else if (type) {
        var obj = {};

        ks[type].forEach(function(k) {
          obj[k] = {
            balance: "",
            critical: false,
            criticality_threshold: 90,
            duty_expressions: [self.emptyDutyExpression()]
          };
        });

        return obj;
      }
    },
    resetOpeningBalances: function() {
      var newOpeningBalances = [];

      this.section.duty_expressions.splice(0, 100);
      this.section.staged = false;
      this.section.duties_each_period = false;
      this.section.criticality_each_period = false;

      if (this.section.periods) {
        this.section.periods.splice(0, 100);
      } else {
        this.section.periods = [];
      }

      if (this.section.type == "custom") {
        this.addPeriod();
      } else {

        if (!this.section.duties_each_period) {
          this.section.duty_expressions.push(this.emptyDutyExpression());
        }

        this.section.balance = this.balanceForType(this.section.type);

        if (this.section.period == "1" || this.section.period == "1_repeating") {
          newOpeningBalances.push(this.blankOpeningBalance(this.section.type));
        } else {
          var years = parseInt(this.section.period, 10);

          for (var i = 1; i <= years; i++) {
            newOpeningBalances.push(this.blankOpeningBalance(this.section.type));
          }
        }

        this.section.opening_balances = newOpeningBalances;
      }
    },
    removePeriod: function(index) {
      this.section.periods.splice(index, 1);

      if (this.section.periods.length === 0) {
        this.addPeriod();
      }
    },
    addPeriod: function() {
      this.section.periods.push({
        start_date: "",
        end_date: "",
        balance: "",

        duty_expressions: [this.emptyDutyExpression()],
        critical: false,
        criticality_threshold: 80,

        measurement_unit_id: "",
        measurement_unit_qualifier_id: ""
      });
    }
  },
  computed: {
    showOpeningBalanceFields: function() {
      if (this.section.type == "custom") {
        return true;
      }

      if (!this.section.type || !this.section.start_date || !this.section.period || !(this.section.measurement_unit_code || this.section.monetary_unit_code)) {
        return false;
      }

      return true;
    },
    disableStaged: function() {
      return ["1", "1_repeating"].indexOf(this.section.period) > -1;
    },
    disableCriticality: function() {
      var check = ["1_repeating"];

      if (this.section.type == "annual") {
        check.push("1");
      }

      return check.indexOf(this.section.period) > -1;
    },
    disableDuties: function() {
      var check = ["1_repeating"];

      if (this.section.type == "annual") {
        check.push("1");
      }

      return check.indexOf(this.section.period) > -1;
    },
    omitCriticality: function() {
      return window.all_settings.quota_is_licensed == "true";
    },
    maxDate: function() {
      if (this.section.type != "custom") {
        return null;
      }

      try {
        var date = moment(this.section.periods[0].start_date, ["DD MMM YYYY", "DD/MM/YYYY"], true);

        if (!date.isValid()) {
          return null;
        }

        return date.add(1, "year").format("DD/MM/YYYY");
      } catch (e) {
        return null;
      }
    },
    canAddMorePeriods: function() {
      if (this.section.periods.length === 0 || !this.maxDate) {
        return true;
      }

      var last = moment(this.section.periods[this.section.periods.length - 1].end_date, "DD/MM/YYYY", true);

      if (!last.isValid()) {
        return false;
      }

      return moment(this.maxDate, "DD/MM/YYYY", true).diff(last, "days") >= 1;
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
        this.section.parent_quota.associate = false;

        if (!this.section.parent_quota.balances) {
          this.section.parent_quota.balances = [];
        }

        if (newVal == "annual" && !this.section.period) {
          this.section.period = this.periods[0].id;
        }

        this.section.parent_quota.balances.splice(0, 999);
      }
    },
    "section.period": function() {
      this.resetOpeningBalances();
      this.section.parent_quota.associate = false;

      if (!this.section.parent_quota.balances) {
        this.section.parent_quota.balances = [];
      }

      this.section.parent_quota.balances.splice(0, 999);
    }
  }
});
