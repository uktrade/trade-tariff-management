Vue.component("measure-change-commodity-code-input", {
  template: "#measure-change-commodity-code-input-template",
  props: ["commodityCode"],
  inject: ["setCommodityCode"],
  methods: {
    updateCommodityCode: function(evt){
      var newCommodityCode = evt.target.value;
      this.setCommodityCode(this.commodityCode, newCommodityCode);
    }
  }
});
