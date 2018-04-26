$(document).ready(function() {
  var form = document.querySelector(".regulation-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        antidumpingRoles: ["2", "3"],
        communityCodes: [
          { value: "1", text: "Economic" },
          { value: "2", text: "Atomic" },
          { value: "3", text: "Coal" },
          { value: "4", text: "Economic/Coal"}
        ]
      };

      if (window.__regulation_json) {
        data.regulation = this.parseRegulationPayload(window.__regulation_json);
      } else {
        data.regulation = this.emptyRegulation();
      }

      if (!data.regulation.replacement_indicator) {
        data.regulation.replacement_indicator = "0";
      }

      return data;
    },
    computed: {
      dependentOnBaseRegulation: function() {
        return $.inArray(this.regulation.role, ['4', '6', '7']) !== -1;
      },
      canHaveRelatedAntidumpingLink: function() {
        var roles = ["2", "3"];

        return roles.indexOf(this.regulation.role) > -1;
      },
      showCommunityCode: function() {
        return $.inArray(this.regulation.role, ["1", "2", "3"]) !== -1;
      },
      showValidityPeriod: function() {
        return $.inArray(this.regulation.role, ["1", "2", "3", "4", "8"]) !== -1;
      },
      showRegulationGroup: function() {
        return $.inArray(this.regulation.role, ["1", "2", "3"]) !== -1;
      },
      showPublishedDate: function() {
        return $.inArray(this.regulation.role, ["5", "6", "7", "8"]) !== -1;
      },
      isExplicitAbrogation: function() {
        return this.regulation.role === "7";
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
          replacement_indicator: "0",
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
      }
    }
  });
});
