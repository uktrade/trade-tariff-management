Vue.component("measure-change-additional-code-input", {
  template: "#measure-change-additional-code-input-template",
  props: ["additionalCode"],
  inject: [
    "setAdditionalCode",
    "additionalCodeForRemoval",
    "additionalCodeNotForRemoval"
  ],
  data: function(){
    return {
      removeAdditionalCode: false,
      newAdditionalCode: "",
      isWrong: false
    };
  },
  watch: {
    removeAdditionalCode: function(){
      if (this.removeAdditionalCode) {
        this.setAdditionalCode(this.additionalCode, null);
        this.additionalCodeForRemoval(this.additionalCode);
      } else {
        this.setAdditionalCode(this.additionalCode, this.newAdditionalCode);
        this.additionalCodeNotForRemoval(this.additionalCode);
      }
    },
    newAdditionalCode: function(){
      this.setAdditionalCode(this.additionalCode, this.newAdditionalCode);
      this.isWrong = this.newAdditionalCode !== "" && this.newAdditionalCode.length !== 4;
    }
  }
});
