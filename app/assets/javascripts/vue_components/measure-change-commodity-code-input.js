Vue.component("measure-change-commodity-code-input", {
  template: "#measure-change-commodity-code-input-template",
  props: ["commodityCode"],
  inject: ["setCommodityCode"],
  data: function(){
    return {
      labelUid: "commodity_code_input_" + this.commodityCode
    };
  },
  methods: {
    updateCommodityCode: function(evt){
      var newCommodityCode = evt.target.value;
      this.setCommodityCode(this.commodityCode, newCommodityCode);
    }
  }
});
