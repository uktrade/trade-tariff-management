//= require ./custom-select

$(document).ready(function() {
  var form = document.querySelector(".regulation-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {};

      if (window.__regulation_json) {
        data.regulation = this.parseRegulationPayload(window.__regulation_json);
      } else {
        data.regulation = this.emptyRegulation();
      }

      return data;
    },
    computed: {
      dependentOnBaseRegulation: function() {
        var roles = ["1", "7", "6", "8", "5"];

        return this.regulation.role && roles.indexOf(this.regulation.role) === -1;
      },
      canHaveCompleteAbrogationLink: function() {
        var roles = ["1", "4"];

        return roles.indexOf(this.regulation.role) > -1;
      },
      canHaveExplicitAbrogationLink: function() {
        var roles = ["1", "8", "4"];

        return roles.indexOf(this.regulation.role) > -1;
      },
      canAbrogate: function() {
        var roles = ["1", "2", "3"];

        return roles.indexOf(this.regulation.role) > -1;
      }
    },
    methods: {
      parseRegulationPayload: function(payload) {
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
      onCompleteAbrogationRegulationChange: function(item) {
        if (!item) {
          return;
        }

        this.regulation.complete_abrogation_regulation_role = item.role;
      },
      onExplicitAbrogationRegulationChange: function(item) {
        if (!item) {
          return;
        }

        this.regulation.explicit_abrogation_regulation_role = item.role;
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
