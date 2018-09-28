$(document).ready(function() {
  var form = document.querySelector(".geographical-area-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        savedSuccessfully: false,
        errors: []
      };

      if (window.__geographical_area_json) {
        data.geographical_area = this.parseGeographicalAreaPayload(window.__geographical_area_json);
      } else {
        data.geographical_area = this.emptyGeographicalArea();
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

          self.savedSuccessfully = false;
          WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));
          var http_method = "PUT";

          if (window.current_step == 'main') {
            var payload = self.createGeographicalAreaMainStepPayLoad();
          }

          self.errors = [];

          $.ajax({
            url: window.save_url,
            type: http_method,
            data: {
              step: window.current_step,
              mode: submit_button.attr('name'),
              settings: payload
            },
            success: function(response) {
              WorkbasketBaseSaveActions.handleSuccessResponse(response, submit_button.attr('name'), function() {
                self.savedSuccessfully = true;
              });
            },
            error: function(response) {
              WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock();
              self.errors = response.responseJSON.errors;
              WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();
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
      parseGeographicalAreaPayload: function(payload) {
        return {
          geographical_code: payload.geographical_code,
          geographical_area_id: payload.geographical_area_id,
          parent_geographical_area_group_sid: payload.parent_geographical_area_group_sid,
          validity_start_date: payload.validity_start_date,
          validity_end_date: payload.validity_end_date,
          operation_date: payload.operation_date
        };
      },
      emptyGeographicalArea: function() {
        return {
          geographical_code: null,
          geographical_area_id: null,
          parent_geographical_area_group_sid: null,
          validity_start_date: null,
          validity_end_date: null,
          operation_date: null
        }
      },
      createGeographicalAreaMainStepPayLoad: function() {
        return {
          geographical_code: this.geographical_area.geographical_code,
          geographical_area_id: this.geographical_area.geographical_area_id,
          parent_geographical_area_group_sid: this.geographical_area.parent_geographical_area_group_sid,
          validity_start_date: this.geographical_area.validity_start_date,
          validity_end_date: this.geographical_area.validity_end_date,
          operation_date: this.geographical_area.operation_date,
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
