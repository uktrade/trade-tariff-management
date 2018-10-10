Vue.component("change-additional-code-popup", {
  template: "#change-additional-code-popup-template",
  data: function(){
    return {
      removeAdditionalCodes: [],
      measuresAdditionalCodes: [],
      allCodesValid: true
    };
  },
  props: ["measures", "onClose", "open"],
  mounted: function(){
    var allAdditionalCodes = this.measures.map(function(measure){
      return measure.additional_code;
    });
    this.measuresAdditionalCodes = allAdditionalCodes.filter(function(code, index, self){
      return self.indexOf(code) == index;
    });
    this.additionalCodesMap = this.measuresAdditionalCodes.reduce(function(map, additionalCode){
      var key = additionalCode || "";
      map[key] = null;
      return map;
    }, {});
  },
  methods: {
    confirmChanges: function(){
      if (!this.allCodesValid) { return; }
      var measuresChangesObjs = [];
      for (var currentAdditionalCode in this.additionalCodesMap) {
        if (this.additionalCodesMap.hasOwnProperty(currentAdditionalCode)) {
          var removeAdditionalCode, newAdditionalCode;
          removeAdditionalCode = this.removeAdditionalCodes.includes(currentAdditionalCode);
          newAdditionalCode = removeAdditionalCode ? "" : this.additionalCodesMap[currentAdditionalCode];

          if (!!newAdditionalCode || removeAdditionalCode) {
            var matchingMeasures = this.measures.filter(function(measure){
              return currentAdditionalCode == (measure.additional_code || "");
            });
            measuresChangesObjs.push({
              matchingMeasures: matchingMeasures,
              newAdditionalCode: newAdditionalCode
            });
          }
        }
      }

      measuresChangesObjs.forEach(function(measuresChangesObj){
        measuresChangesObj.matchingMeasures.forEach(function(measure){
          if (measure.additional_code != measuresChangesObj.newAdditionalCode) {
            measure.additional_code = measuresChangesObj.newAdditionalCode;

            if (measure.changes.indexOf("additional_code") == -1) {
              measure.changes.push("additional_code");
            }
          }
        });
      });

      this.$emit("measures-updated");
      this.onClose();
    },
    triggerClose: function(){
      this.onClose();
    },
    setAdditionalCode: function(currentAdditionalCode, newAdditionalCode){
      var key = currentAdditionalCode || "";
      this.additionalCodesMap[key] = newAdditionalCode;
      this.additionalCodesChanged();
    },
    additionalCodeForRemoval: function(currentAdditionalCode){
      this.removeAdditionalCodes.push(currentAdditionalCode);
    },
    additionalCodeNotForRemoval: function(currentAdditionalCode){
      var idx = this.removeAdditionalCodes.indexOf(currentAdditionalCode);
      if (idx != -1) {
        this.removeAdditionalCodes.splice(idx, 1);
      }
    },
    additionalCodesChanged: function(){
      this.allCodesValid = true;
      for (var code in this.additionalCodesMap) {
        if (this.additionalCodesMap.hasOwnProperty(code)) {
          var value = this.additionalCodesMap[code];
          if (value && value.length !== 4) {
            this.allCodesValid = false;
          }
        }
      }
    }
  },
  provide: function(){
    return {
      setAdditionalCode: this.setAdditionalCode,
      additionalCodeForRemoval: this.additionalCodeForRemoval,
      additionalCodeNotForRemoval: this.additionalCodeNotForRemoval
    };
  }
});
