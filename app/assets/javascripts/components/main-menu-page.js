$(document).ready(function() {

  var form = document.querySelector(".main-menu-page");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      return {
        q: getSearchParam("q")
      };
    },
    computed: {
      emptyFilter: function() {
        if (this.q !== undefined) {
          return this.q.trim().length === 0;
        } else {
          return true
        }
      }
    }
  });
});
