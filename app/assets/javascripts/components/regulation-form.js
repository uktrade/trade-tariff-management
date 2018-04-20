//= require ./custom-select

$(document).ready(function() {
  var form = document.querySelector(".regulation-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        antidumpingRoles: ["2", "3"]
      };

      if (window.__regulation_json) {
        data.regulation = this.parseRegulationPayload(window.__regulation_json);
      } else {
        data.regulation = this.emptyRegulation();
      }

      return data;
    },
    computed: {
      dependentOnBaseRegulation: function() {
        return this.regulation.role === "4";
      },
      canHaveRelatedAntidumpingLink: function() {
        var roles = ["2", "3"];

        return roles.indexOf(this.regulation.role) > -1;
      }
    },
    methods: {
      parseRegulationPayload: function(payload) {
        payload.role = payload.role ? payload.role + "" : payload.role;

        return payload;
      },
      emptyRegulation: function() {
        return {
          type: null,
          base_regulation_id: null,
          base_regulation_role: null,
          validity_start_date: null,
          validity_end_date: null,
          effective_enddate: null,
          validity_start_date: null,
          validity_start_date: null,
        }
      },
      onBaseRegulationChange: function(item) {
        if (!item) {
          return;
        }

        this.regulation.base_regulation_role = item.role;
      },
      onRelatedAntidumpingRegulationChange: function(item) {
        if (!item) {
          return;
        }

        this.regulation.antidumping_regulation_role = item.role;
      }
    }
  });
});
