var template = `
<div class="parent-quota-opening-balances">
  <div class="bootstrap-row" v-if="single">
    <div class="col-xs-5 col-sm-4 col-md-3 col-lg-2">
      <div class="form-group">
        <input type="text" class="form-control" v-model="balances[0].balance"/>
      </div>
    </div>
  </div>

  <div v-else>
    <div class="bootstrap-row" v-for="(balance, index) in balances">
      <div class="col-xs-7 col-sm-4 col-md-3 col-lg-2">
        Year {{index + 1}}
      </div>

      <div class="col-xs-5 col-sm-4 col-md-3 col-lg-2">
        <div class="form-group">
          <input type="text" class="form-control" v-model="balance.balance"/>
        </div>
      </div>
    </div>
  </div>
</div>
`;

Vue.component("parent-quota-opening-balances", {
  template: template,
  props: ["section", "balances"],
  mounted: function() {
    if (this.balances.length === 0) {
      this.recalculateBalances();
    }
  },
  computed: {
    single: function() {
      return this.section.type == "custom" || ["1", "1_repeating"].indexOf(this.section.period) > -1;
    },
    noPerPeriod: function() {

      if (this.section.type == "annual") {
        return this.single ||
               (
                !this.section.staged &&
                !this.section.criticality_each_period &&
                !this.section.duties_each_period
               );
      }

      return !this.section.staged &&
             !this.section.criticality_each_period &&
             !this.section.duties_each_period;
    },
    /**
     * Watching this computed property will enable us to recalculate the individual balances here
     *
     * @returns Float
     */
    total: function() {
      var self = this;

      var ks = {
        bi_annual: ["semester1", "semester2"],
        quarterly: ["quarter1", "quarter2", "quarter3", "quarter4"],
        monthly: ["month1", "month2", "month3", "month4", "month5", "month6", "month7", "month8", "month9", "month10", "month11", "month12"]
      };

      if (this.section.type == "custom") {
        return this.section.periods.map(function(p) {
          return parseFloat(p.balance);
        }).reduce(function(acc, current) {
          return acc + current;
        });
      } else {
        if (this.section.type == "annual" && this.noPerPeriod) {
          return parseFloat(this.section.balance.balance);
        } else if (this.noPerPeriod) {
          return ks[this.section.type].map(function(k) {
            return parseFloat(self.section.balance[k].balance);
          }).reduce(function(acc, current) {
            return acc + current;
          });
        } else {
          return this.section.opening_balances.map(function(balance) {
            return ks[self.section.type].map(function(k) {
              return parseFloat(balance[k].balance);
            }).reduce(function(acc, current) {
              return acc + current;
            });
          });
        }
      }
    }
  },
  watch: {
    total: function(newVal, oldVal) {
      if (oldVal && newVal && oldVal != newVal) {
        this.recalculateBalances();
      }
    }
  },
  methods: {
    recalculateBalances: function() {
      var newBalances = [];

      var self = this;

      var ks = {
        bi_annual: ["semester1", "semester2"],
        quarterly: ["quarter1", "quarter2", "quarter3", "quarter4"],
        monthly: ["month1", "month2", "month3", "month4", "month5", "month6", "month7", "month8", "month9", "month10", "month11", "month12"]
      };

      if (this.section.type == "custom") {
        var balance = this.section.periods.map(function(p) {
          return parseFloat(p.balance);
        }).reduce(function(acc, current) {
          return acc + current;
        });

        newBalances.push({
          balance: balance
        });
      } else {
        if (this.section.type == "annual" && this.noPerPeriod) {
          var balance = parseFloat(self.section.balance.balance);

          newBalances.push({
            balance: balance
          });
        } else if (this.noPerPeriod) {
          var balance = ks[this.section.type].map(function(k) {
            return parseFloat(self.section.balance[k].balance);
          }).reduce(function(acc, current) {
            return acc + current;
          });

          newBalances.push({
            balance: balance
          });
        } else {
          this.section.opening_balances.forEach(function(balance) {
            var b = ks[self.section.type].map(function(k) {
              return parseFloat(balance[k].balance);
            }).reduce(function(acc, current) {
              return acc + current;
            });

            newBalances.push({
              balance: b
            });
          });
        }
      }

      this.balances = newBalances;
    }
  }
});
