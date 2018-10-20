$(document).ready(function() {
  var form = document.querySelector(".js-edit-footnote-form");

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

      if (!$.isEmptyObject(window.__footnote_json)) {
        data.footnote = this.parseFootnotePayload(window.__footnote_json);
      } else {
        data.footnote = this.emptyFootnote();
      }

      data.footnote_types_list = window.__footnote_types_list_json;

      return data;
    },
    mounted: function() {
      var self = this;

      var changes_take_effect_date_input = $(".js-changes_take_effect_date_input");
      var description_validity_period_date_input = $(".js-description-validity-period-date");

      var changes_take_effect_date_picker = new Pikaday({
        field: changes_take_effect_date_input[0],
        format: "DD/MM/YYYY",
        blurFieldOnSelect: true,
        onSelect: function(value) {
          changes_take_effect_date_input.trigger("change");
          console.log('---------------- select ----------------');
        }
      });

      var description_validity_period_date_picker = new Pikaday({
        field: description_validity_period_date_input[0],
        format: "DD/MM/YYYY",
        blurFieldOnSelect: true,
        onSelect: function(value) {
          description_validity_period_date_input.trigger("change");
        }
      });

      changes_take_effect_date_input.on("change", function() {
        if (!$(this).val()) {
          console.log('---------------- change - zero value ----------------');
        }
      });

      $(document).on('click', ".js-create-measures-v1-submit-button, .js-workbasket-base-submit-button", function(e) {
        e.preventDefault();
        e.stopPropagation();

        submit_button = $(this);

        self.savedSuccessfully = false;
        WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));
        self.errors = [];

        $.ajax({
          url: window.save_url,
          type: "PUT",
          data: {
            step: window.current_step,
            mode: submit_button.attr('name'),
            settings: self.createFootnoteMainStepPayLoad()
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

            json_resp = response.responseJSON;

            self.errorsSummary = json_resp.errors_summary;
            self.errors = json_resp.errors;
            self.conformanceErrors = json_resp.conformance_errors;
          }
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
    watch: {
      "footnote.description": function(newVal) {
        if (newVal && newVal !== window.__original_footnote_description) {
          console.log("-----------------" + newVal);
        }
      }
    },
    methods: {
      parseFootnotePayload: function(payload) {
        return {
          reason_for_changes: payload.reason_for_changes,
          operation_date: payload.operation_date,
          description: payload.description,
          description_validity_start_date: payload.description_validity_start_date,
          validity_start_date: payload.validity_start_date,
          validity_end_date: payload.validity_end_date,
          commodity_codes: payload.commodity_codes,
          measure_sids: payload.measure_sids
        };
      },
      emptyFootnote: function() {
        return {
          reason_for_changes: null,
          operation_date: null,
          description: null,
          description_validity_start_date: null,
          validity_start_date: null,
          validity_end_date: null,
          commodity_codes: null,
          measure_sids: null
        };
      },
      createFootnoteMainStepPayLoad: function() {
        return {
          reason_for_changes: this.footnote.reason_for_changes,
          operation_date: this.footnote.operation_date,
          description: this.footnote.description,
          description_validity_start_date: this.footnote.description_validity_start_date,
          validity_start_date: this.footnote.validity_start_date,
          validity_end_date: this.footnote.validity_end_date,
          commodity_codes: this.footnote.commodity_codes,
          measure_sids: this.footnote.measure_sids
        };
      }
    }
  });
});
