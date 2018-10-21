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
        errors: {},
        conformanceErrors: {},
        errorsSummary: ""
      };

      var types = {
        country: {
          selected: false
        },
        group: {
          selected: false
        },
        region: {
          selected: false
        }
      }

      if (!$.isEmptyObject(window.__geographical_area_json)) {
        data.geographical_area = this.parseGeographicalAreaPayload(window.__geographical_area_json);

        if (data.geographical_area.geographical_code) {
          types[data.geographical_area.geographical_code]['selected'] = true;
        }
      } else {
        data.geographical_area = this.emptyGeographicalArea();
      }

      data.types = types;

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

          self.errors = {};
          self.conformanceErrors = {};

          $.ajax({
            url: window.save_url,
            type: "PUT",
            data: {
              step: window.current_step,
              mode: submit_button.attr('name'),
              settings: self.createGeographicalAreaMainStepPayLoad()
            },
            success: function(response) {
              WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock();

              if (response.redirect_url !== undefined) {
                setTimeout(function tick() {
                  window.location = response.redirect_url;
                }, 1000);
              } else {
                WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();
                self.savedSuccessfully = true;
              }
            },
            error: function(response) {
              WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock();
              WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();

              if (response.status == 500) {
                alert("There was a server error which prevented the additional codes to be saved. Please try again in a few moments.");
                return;
              }

              self.errorsSummary = "All bad guys!";
              self.errors = response.responseJSON.errors;
            }
          });
        });
      });
    },
    computed: {
      hasErrors: function() {
        return Object.keys(this.errors).length > 0;
      },
      hasConformanceErrors: function() {
        return Object.keys(this.conformanceErrors).length > 0;
      }
    },
    methods: {
      parseGeographicalAreaPayload: function(payload) {
        return {
          geographical_code: payload.geographical_code,
          geographical_area_id: payload.geographical_area_id,
          parent_geographical_area_group_id: payload.parent_geographical_area_group_id,
          description: payload.description,
          validity_start_date: payload.validity_start_date,
          validity_end_date: payload.validity_end_date,
          operation_date: payload.operation_date
        };
      },
      emptyGeographicalArea: function() {
        return {
          geographical_code: null,
          geographical_area_id: null,
          parent_geographical_area_group_id: null,
          description: null,
          validity_start_date: null,
          validity_end_date: null,
          operation_date: null
        };
      },
      createGeographicalAreaMainStepPayLoad: function() {
        geographical_code = $("input[name='geographical_area[geographical_code]']").val();

        if (geographical_code.length > 0 && geographical_code == 'on') {
          geographical_code = '';
        }

        return {
          geographical_code: geographical_code,
          geographical_area_id: this.geographical_area.geographical_area_id,
          parent_geographical_area_group_id: $("select[name='geographical_area[parent_geographical_area_group_id]']").val(),
          description: this.geographical_area.description,
          validity_start_date: this.geographical_area.validity_start_date,
          validity_end_date: this.geographical_area.validity_end_date,
          operation_date: this.geographical_area.operation_date,
        };
      }
    }
  });
});
