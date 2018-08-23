Vue.component("change-commodity-code-popup", {
  template: "#change-commodity-code-popup-template",
  data: function() {
    return {
      measuresCommodityCodes: [],
      wrongCodes: [],
      validatingCodes: false
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
    validateCommodityCodes: function(){
      var self = this,
          requests = [];
      this.wrongCodes = [];
      this.validatingCodes = true;
      for (var currentCommodityCode in this.commodityCodesMap) {
        if (this.commodityCodesMap.hasOwnProperty(currentCommodityCode)) {
          var newCommodityCode = this.commodityCodesMap[currentCommodityCode];
          if (newCommodityCode) {
            if (newCommodityCode.length != 10) {
              this.wrongCodes.push(newCommodityCode);
            } else {
              var jqxhr = $.ajax({
                url: "/goods_nomenclatures?q=" + newCommodityCode,
                type: "GET",
                context: newCommodityCode
              });
              jqxhr.fail(function(){
                self.wrongCodes.push(this.valueOf());
              });
              requests.push(jqxhr);
            }
          }
        }
      }
      var deferred = $.Deferred();
      $.when.apply(undefined, requests).always(function(){
        self.validatingCodes = false;
        deferred.resolve(self.wrongCodes.length == 0);
      });
      return deferred;
    },
    confirmChanges: function() {
      var self = this;
      this.validateCommodityCodes().done(function(validCommodityCodes){
        if (validCommodityCodes) {
          self.applyChanges();
        }
      });
    },
    applyChanges: function(){
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
    }
  },
  provide: function(){
    return { setCommodityCode: this.setCommodityCode };
  }
});
