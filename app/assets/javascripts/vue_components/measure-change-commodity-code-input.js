Vue.component("measure-change-commodity-code-input", {
  template: "#measure-change-commodity-code-input-template",
  props: ["commodityCode", "wrongCodes"],
  inject: ["setCommodityCode"],
  data: function(){
    return {
      newCommodityCode: null,
      labelUid: "commodity_code_input_" + this.commodityCode
    };
  },
  methods: {
    updateCommodityCode: function(evt){
      this.newCommodityCode = evt.target.value;
      this.setCommodityCode(this.commodityCode, this.newCommodityCode);
    }
  },
  computed: {
    wrongCommodityCode: function(){
      return this.wrongCodes.includes(this.newCommodityCode);
    }
  }
});
