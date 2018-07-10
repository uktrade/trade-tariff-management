Vue.component("measure-additional-code-previewer", {
  template: "#measure-additional-code-previewer-template",
  data: function(){
    return {
      loadingAdditionalCode: false,
      desiredAdditionalCode: "",
      desiredAdditionalCodeHTML: ""
    };
  },
  watch: {
    desiredAdditionalCode: function(val){
      this.desiredAdditionalCodeHTML = "";

      if (val.length != 4) { return; }

      var self = this;

      this.loadingAdditionalCode = true;

      jqxhr = $.ajax({
        url: "/additional_codes/preview?code=" + val,
        type: "GET"
      });

      jqxhr.done(function(resp){
        self.desiredAdditionalCodeHTML = resp;
      });

      jqxhr.fail(function(){
        self.desiredAdditionalCodeHTML = "Something went wrong. Check the Additional Code and please try again.";
      });

      jqxhr.always(function(){
        self.loadingAdditionalCode = false;
      });
    }
  }
});
