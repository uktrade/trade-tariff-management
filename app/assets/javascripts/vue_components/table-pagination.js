var template = [
  "<ul class='pagination' v-if='shouldShow'>",
    "<li v-if='showFirst'><a class='pagination-link pagination-link--first' v-on:click.prevent='sendClick(1)'>First</a></li>",
    "<li v-for='p in range'>",
      "<a class='pagination-link' href='#' v-on:click.prevent='sendClick(p)' v-if='p != page'>{{p}}</a>",
      "<span v-if='p == page'>{{p}}</span>",
    "</li>",
    "<li v-if='showLast'><a href='#' class='pagination-link pagination-link--last' v-on:click.prevent='sendClick(pages)'>Last</a></li>",
  "</ul>"
].join("");

Vue.component("table-pagination", {
  template: template,
  props: ["page", "perPage", "total", "onClick"],
  computed: {
    isFirst: function() {
      return this.page === 1;
    },
    isLast: function() {
      return this.page === this.pages;
    },
    pages: function() {
      return Math.ceil(this.total / this.perPage);
    },
    range: function() {
      var pages = this.pages;
      var page = this.page;

      var startPage = Math.max(1, page - 5);
      var endPage = Math.min(startPage + 9, pages);

      var arr = [];

      for (var i = startPage; i <= endPage; i++) {
        arr.push(i);
      }

      return arr;
    },
    shouldShow: function() {
      return this.pages > 1;
    },
    showFirst: function() {
      return this.page > 6;
    },
    showLast: function() {
      return this.pages > 10 && this.pages - this.page > 4;
    }
  },
  methods: {
    sendClick: function(page) {
      this.onClick(page);
    }
  }
});
