Vue.component("measure-change-additional-code-input", {
  template: "#measure-change-additional-code-input-template",
  props: ["additionalCode"],
  inject: ["setAdditionalCode"],
  data: function(){
    return {
      removeAdditionalCode: false,
      newAdditionalCode: ""
    };
  },
  watch: {
    removeAdditionalCode: function(){
      if (this.removeAdditionalCode) {
        this.setAdditionalCode(this.additionalCode, null);
      } else {
        this.setAdditionalCode(this.additionalCode, this.newAdditionalCode);
      }
    },
    newAdditionalCode: function(){
      this.setAdditionalCode(this.additionalCode, this.newAdditionalCode);
    }
  }
});
