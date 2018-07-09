Vue.component("measure-commodity-code-previewer", {
  template: "#measure-commodity-code-previewer-template",
  data: function(){
    return {
      loadingCommodityCode: false,
      desiredCommodityCode: "",
      desiredCommodityCodeHTML: ""
    };
  },
  watch: {
    desiredCommodityCode: function(val){
      if (val.length != 10) { return; }

      var self = this;

      this.loadingCommodityCode = true;
      this.desiredCommodityCodeHTML = "";

      jqxhr = $.ajax({
        url: "/goods_nomenclatures?q=" + val,
        type: "GET",
        processData: false
      });

      jqxhr.done(function(resp){
        self.desiredCommodityCodeHTML = resp;
      });

      jqxhr.fail(function(){
        self.desiredCommodityCodeHTML = "Something went wrong. Check the Commodity Code and please try again.";
      });

      jqxhr.always(function(){
        self.loadingCommodityCode = false;
      });
    }
  }
});
