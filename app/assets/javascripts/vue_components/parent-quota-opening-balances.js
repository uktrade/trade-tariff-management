var template = '\
<div class="parent-quota-opening-balances">\
  <div v-if="section.parent_quota.balances && section.parent_quota.balances.length > 0">\
    <div class="bootstrap-row" v-if="single || noPerPeriod">\
      <div class="col-xs-5 col-sm-4 col-md-3 col-lg-2">\
        <div class="form-group" v-for="(balance, index) in section.parent_quota.balances">\
          <input type="text" class="form-control" v-model="balance.balance"/>\
        </div>\
      </div>\
    </div>\
\
    <div v-if="!single && !noPerPeriod">\
      <div class="bootstrap-row parent-quota-balance" v-for="(balance, index) in section.parent_quota.balances">\
        <div class="col-xs-4 col-sm-3 col-md-2 col-lg-1">\
          <label>Year {{index + 1}}</label>\
        </div>\
\
        <div class="col-xs-5 col-sm-4 col-md-3 col-lg-2">\
          <div class="form-group">\
            <input type="text" class="form-control" v-model="balance.balance"/>\
          </div>\
        </div>\
      </div>\
    </div>\
  </div>\
</div>';

Vue.component("parent-quota-opening-balances", {
  template: template,
  props: ["section", "balances", "update-balances"],
  data: function() {
    if (!this.section.parent_quota.balances || this.section.parent_quota.balances.length === 0) {
      this.recalculateBalances();
    }

    return {

    };
  },
  computed: {
    single: function() {
      return this.section.type == "custom" || ["1", "1_repeating"].indexOf(this.section.period) > -1;
    },
    noPerPeriod: function() {
      if (this.section.type == "custom") {
        return true;
      }

      if (this.section.type == "annual") {
        return this.single || !this.section.staged;
      }

      return !this.section.staged;
    },
    /**
     * Watching this computed property will enable us to recalculate the individual balances here
     * DO NOT REMOVE
     *
     * @returns Float
     */
    total: function() {
      return this.sumBalances().map(function(b) {
        return b.balance;
      }).reduce(function(a, b) {
        return a + b;
      });
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
      var newBalances = this.sumBalances();

      this.updateBalances(newBalances);

      // I wasted SO much time trying to understand and trying
      // to fix the UI not updating, so I'm forcing it
      this.$nextTick(function() {
        this.$forceUpdate();
      });
    },
    sumBalances: function() {
      var newBalances = [];

      var self = this;

      var parse = function(n) {
        var f = parseFloat(n);
        if (isNaN(f)) {
          return 0;
        }

        return f;
      }

      var ks = {
        bi_annual: ["semester1", "semester2"],
        quarterly: ["quarter1", "quarter2", "quarter3", "quarter4"],
        monthly: ["month1", "month2", "month3", "month4", "month5", "month6", "month7", "month8", "month9", "month10", "month11", "month12"]
      };

      if (this.section.type == "custom") {
        var balance = this.section.periods.map(function(p) {
          return parse(p.balance);
        }).reduce(function(acc, current) {
          return acc + current;
        });

        newBalances.push({
          balance: balance
        });
      } else {
        if (this.section.type == "annual" && this.noPerPeriod) {
          var balance = parse(self.section.balance);

          newBalances.push({
            balance: balance
          });
        } else if (this.noPerPeriod) {
          var balance = ks[this.section.type].map(function(k) {
            return parse(self.section.balance[k]);
          }).reduce(function(acc, current) {
            return acc + current;
          });

          newBalances.push({
            balance: balance
          });
        } else {
          this.section.opening_balances.forEach(function(balance) {
            if (self.section.type == "annual") {
              var b = parse(balance.balance);

              newBalances.push({
                balance: b
              });
            } else {
              var b = ks[self.section.type].map(function(k) {
                return parse(balance[k].balance);
              }).reduce(function(acc, current) {
                return acc + current;
              });

              newBalances.push({
                balance: b
              });
            }
          });
        }
      }

      return newBalances;
    }
  }
});
