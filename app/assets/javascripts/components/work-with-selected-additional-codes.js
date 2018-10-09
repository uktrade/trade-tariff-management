$(document).ready(function() {

  var form = document.querySelector(".work-with-selected-additional-codes");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      return {
        reason: "",
        title: "",
        date: moment().add(1, "day").format("DD/MM/YYYY")
      };
    },
    computed: {
      disableSubmit: function() {
        return this.title.trim().length < 1 || this.reason.trim().length < 1;
      }
    }
  });
});
