var template = [
  "<div class='loading-indicator'>",
    "<h2 class='heading-xlarge' slot='title'>Loading</h2>",
    "<slot :start='start' :end='end' :total='total'><h4>{{start}} to {{end}} of {{total}}</h4></slot>",
  "</div>"
].join("");

Vue.component("loading-indicator", {
  template: template,
  props: ["metadata"],
  computed: {
    percentage: function() {
      return ((done * 100) / total).toFixed(2);
    },
    start: function() {
      return (this.metadata.page - 1)  * this.metadata.per_page + 1;
    },
    end: function() {
      return Math.min(this.start + this.metadata.per_page - 1, this.total);
    },
    total: function() {
      return this.metadata.total_count;
    }
  }
});
