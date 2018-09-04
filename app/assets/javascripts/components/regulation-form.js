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
        ],
        errors: []
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
    mounted: function() {
      var self = this;

      $(document).ready(function(){
        $(document).on('click', ".js-create-measures-v1-submit-button, .js-workbasket-base-submit-button", function(e) {
          e.preventDefault();
          e.stopPropagation();

          submit_button = $(this);

          WorkbasketBaseSaveActions.hideSuccessMessage();
          WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));
          var http_method = "PUT";

          if (window.current_step == 'main') {
            var payload = self.createRegulationMainStepPayLoad();
          }

          var data_ops = {
            step: window.current_step,
            mode: submit_button.attr('name'),
            settings: payload
          };

          self.errors = [];

          $.ajax({
            url: window.save_url,
            type: http_method,
            data: data_ops,
            success: function(response) {
              WorkbasketBaseSaveActions.handleSuccessResponse(response, submit_button.attr('name'));
            },
            error: function(response) {
              WorkbasketBaseValidationErrorsHandler.handleErrorsResponse(response, self);
            }
          });
        });
      });
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
      },
      hasErrors: function() {
        return this.errors.length > 0;
      }
    },
    methods: {
      parseRegulationPayload: function(payload) {
        return {
          role: payload.role ? payload.role + "" : payload.role,
          prefix: payload.prefix,
          publication_year: payload.publication_year,
          regulation_number: payload.regulation_number,
          number_suffix: payload.number_suffix,
          information_text: payload.information_text,
          effective_end_date: payload.effective_end_date,
          regulation_group_id: payload.regulation_group_id,
          base_regulation_id: payload.base_regulation_id,
          base_regulation_role: payload.base_regulation_role,
          replacement_indicator: payload.replacement_indicator,
          community_code: payload.community_code,
          officialjournal_number: payload.officialjournal_number,
          officialjournal_page: payload.officialjournal_page,
          antidumping_regulation_role: payload.antidumping_regulation_role,
          related_antidumping_regulation_id: payload.related_antidumping_regulation_id,
          published_date: payload.published_date
        };
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
          related_antidumping_regulation_id: null,
          published_date: null,
          operation_date: null
        }
      },
      createRegulationMainStepPayLoad: function() {
        return {
          role: this.regulation.role,
          prefix: this.regulation.prefix,
          publication_year: this.regulation.publication_year,
          regulation_number: this.regulation.regulation_number,
          number_suffix: this.regulation.number_suffix,
          information_text: this.regulation.information_text,
          effective_end_date: this.regulation.effective_end_date,
          regulation_group_id: this.regulation.regulation_group_id,
          base_regulation_id: this.regulation.base_regulation_id,
          base_regulation_role: this.regulation.base_regulation_role,
          replacement_indicator: this.regulation.replacement_indicator,
          community_code: this.regulation.community_code,
          officialjournal_number: this.regulation.officialjournal_number,
          officialjournal_page: this.regulation.officialjournal_page,
          antidumping_regulation_role: this.regulation.antidumping_regulation_role,
          related_antidumping_regulation_id: this.regulation.related_antidumping_regulation_id,
          start_date: this.regulation.validity_start_date,
          validity_start_date: this.regulation.validity_start_date,
          end_date: this.regulation.validity_end_date,
          validity_end_date: this.regulation.validity_end_date,
          operation_date: this.regulation.operation_date,
          published_date: this.regulation.published_date
        };
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
