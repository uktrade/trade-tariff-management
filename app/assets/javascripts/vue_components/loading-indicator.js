var template = [
  "<pop-up :open='true'>",
    "<div class='loading-indicator-popup'>",
      "<h2>Loading</h2>",
      "<h4>{{start}} to {{end}} of {{total}}</h4>",
    "</div>",
  "</pop-up>"
].join("");

Vue.component("loading-indicator", {
  template: template,
  props: ["metadata"],
  computed: {
    percentage: function() {
      return ((done * 100) / total).toFixed(2);
    },
    start: function() {
      return (this.metadata.page - 1) * this.metadata.per_page + 1;
    },
    end: function() {
      return this.start + this.metadata.per_page - 1;
    },
    total: function() {
      return this.metadata.total_count;
    }
  }
});
