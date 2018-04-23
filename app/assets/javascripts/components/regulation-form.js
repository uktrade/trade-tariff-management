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

      // TODO: fix me
      data.errors = {};

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
          role: null,
          prefix: null,
          publication_year: null,
          regulation_number: null,
          number_suffix: null,
          information_text: null,
          validity_start_date: null,
          validity_end_date: null,
          effective_end_date: null,
          regulation_group_id: null,
          base_regulation_id: null,
          base_regulation_role: null,
          replacement_indicator: null,
          community_code: null,
          officialjournal_number: null,
          officialjournal_page: null,
          antidumping_regulation_role: null,
          related_antidumping_regulation_id: null
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
      },
      save: function(url, success, error) {
        $.ajax({
          url: url,
          type: "POST",
          data: {
            regulation_form: this.regulation
          },
          success: success,
          error: function(response) {
            error(response.responseJSON.errors);
          }
        })
      }
    }
  });
});
