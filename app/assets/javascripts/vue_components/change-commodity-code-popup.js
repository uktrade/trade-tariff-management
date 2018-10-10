Vue.component("change-commodity-code-popup", {
  template: "#change-commodity-code-popup-template",
  data: function() {
    return {
      measuresCommodityCodes: [],
      allCodesValid: true
    };
  },
  props: ["measures", "onClose", "open"],
  mounted: function() {
    var allCommodityCodes = this.measures.map(function(measure){
      return measure.goods_nomenclature.goods_nomenclature_item_id;
    });
    this.measuresCommodityCodes = allCommodityCodes.filter(function(code, index, self){
      return self.indexOf(code) == index;
    });
    this.commodityCodesMap = this.measuresCommodityCodes.reduce(function(map, commodityCode){
      var key = commodityCode || "";
      map[key] = null;
      return map;
    }, {});
  },
  methods: {
    confirmChanges: function() {
      if (!this.allCodesValid) { return; }
      var measuresChangesObjs = [];
      for (var currentCommodityCode in this.commodityCodesMap) {
        if (this.commodityCodesMap.hasOwnProperty(currentCommodityCode)) {
          var newCommodityCode = this.commodityCodesMap[currentCommodityCode];

          if (!!newCommodityCode) {
            var matchingMeasures = this.measures.filter(function(measure){
              return currentCommodityCode == (measure.goods_nomenclature.goods_nomenclature_item_id || "");
            });
            measuresChangesObjs.push({
              matchingMeasures: matchingMeasures,
              newCommodityCode: newCommodityCode
            });
          }
        }
      }

      measuresChangesObjs.forEach(function(measuresChangesObj){
        measuresChangesObj.matchingMeasures.forEach(function(measure){
          if (measure.goods_nomenclature.goods_nomenclature_item_id != measuresChangesObj.newCommodityCode) {
            measure.goods_nomenclature.goods_nomenclature_item_id = measuresChangesObj.newCommodityCode;

            if (measure.changes.indexOf("goods_nomenclature") == -1) {
              measure.changes.push("goods_nomenclature");
            }
          }
        });
      });

      this.$emit("measures-updated");
      this.onClose();
    },
    triggerClose: function() {
      this.onClose();
    },
    setCommodityCode: function(currentCommodityCode, newCommodityCode){
      var key = currentCommodityCode || "";
      this.commodityCodesMap[key] = newCommodityCode;
      this.commodityCodesChanged();
    },
    commodityCodesChanged: function(){
      this.allCodesValid = true;
      for (var code in this.commodityCodesMap) {
        if (this.commodityCodesMap.hasOwnProperty(code)) {
          var value = this.commodityCodesMap[code];
          if (value && value.length !== 10) {
            this.allCodesValid = false;
          }
        }
      }
    }
  },
  provide: function(){
    return { setCommodityCode: this.setCommodityCode };
  }
});
