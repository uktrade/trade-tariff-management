$(document).ready(function() {

  var form = document.querySelector(".work-with-selected-measures");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      return {
        regulation_id: "",
        notFromRegulation: "",
        reason: "",
        title: ""
      };
    }
  });
});
