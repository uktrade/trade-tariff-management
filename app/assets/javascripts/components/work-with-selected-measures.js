$(document).ready(function() {

  var form = document.querySelector(".work-with-selected-measures");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      return {
        regulation: null,
        regulation_id: null,
        regulation_role: null,
        notFromRegulation: false,
        date: null,
        reason: "",
        title: ""
      };
    },
    computed: {
      disableSubmit: function() {
        if (this.title.trim().length < 1 || this.reason.trim().length < 1) {
          return true;
        }

        if ((!this.regulation_id || !this.regulation_role) && !this.notFromRegulation) {
          return true;
        }

        if (!moment(this.date, "DD/MM/YYYY", true).isValid()) {
          return true;
        }

        return false;
      }
    },
    methods: {
      regulationSelected: function(obj) {
        this.regulation_id = obj.regulation_id;
        this.regulation_role = obj.role;
        this.regulation = obj.regulation;
      }
    },
    watch: {
      notFromRegulation: function(val) {
        if (val) {
          this.regulation_id = null;
          this.regulation_role = null;
        }
      }
    }
  });
});
