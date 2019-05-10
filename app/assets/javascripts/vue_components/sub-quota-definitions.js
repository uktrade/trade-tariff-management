var template = '\
<div className="sub-quota-definitions">\
  <div class="sub-quota-definition bootstrap-row" v-for="(sub_quota, sqi) in definitions">\
    <div class="col-md-3 col-lg-3">\
      <div class="form-group">\
        <label class="form-label" v-if="sqi === 0">\
          Sub quota order number\
        </label>\
\
        <input type="text" class="form-control" v-model="sub_quota.order_number" maxlength="6">\
      </div>\
    </div>\
\
    <div class="col-md-6 col-lg-5">\
      <div class="form-group">\
        <label class="form-label" v-if="sqi === 0">\
          Goods commodity code(s)\
        </label>\
\
        <textarea class="form-control" rows="3" v-model="sub_quota.commodity_codes"></textarea>\
      </div>\
    </div>\
\
    <div class="col-md-2 col-lg-1">\
      <div class="form-group">\
        <label class="form-label" v-if="sqi === 0">\
          Coefficient\
        </label>\
\
        <input type="number" class="form-control" v-model="sub_quota.coefficient" min="0" max="1" step="0.1">\
      </div>\
    </div>\
\
    <div className="col-md-1">\
      <div class="form-group">\
        <label class="form-label" v-if="sqi === 0">&nbsp;</label>\
        <a class="secondary-button" href="#" v-on:click.prevent="clearDefinition(sqi)">Clear</a>\
      </div>\
    </div>\
  </div>\
\
  <p>\
    <a href="#" v-on:click.prevent="addDefinition();">\
      Add another associated sub quota\
    </a>\
  </p>\
</div>';

Vue.component("sub-quota-definitions", {
  template: template,
  props: [
    "definitions"
  ],
  data: function() {
    return {
      key: 1,
    };
  },
  mounted: function() {
    if (this.definitions.length === 0) {
      this.addDefinition();
    }
  },
  methods: {
    addDefinition: function() {
      this.definitions.push({
        key: this.key++,
        order_number: "",
        commodity_codes: "",
        coefficient: ""
      });
    },
    clearDefinition: function(index) {
      var def = this.definitions[index];
      def.order_number = "";
      def.commodity_codes = "";
      def.coefficient = "";
    }
  }
});
