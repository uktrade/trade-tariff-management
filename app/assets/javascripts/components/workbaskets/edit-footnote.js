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

      return data;
    },
    mounted: function() {
      var self = this;

      var description_validity_period_date_input = $(".js-description-validity-period-date");

      var description_validity_period_date_picker = new Pikaday({
        field: description_validity_period_date_input[0],
        format: "DD/MM/YYYY",
        blurFieldOnSelect: true,
        onSelect: function(value) {
          description_validity_period_date_input.trigger("change");
        }
      });

      window.js_start_date_pikaday_instance = description_validity_period_date_picker;

      var changes_take_effect_date_input = $(".js-changes_take_effect_date_input");

      var changes_take_effect_date_picker = new Pikaday({
        field: changes_take_effect_date_input[0],
        format: "DD/MM/YYYY",
        blurFieldOnSelect: true,
        onSelect: function(value) {
          changes_take_effect_date_input.trigger("change");
          new_val = moment(changes_take_effect_date_input.val(), 'DD/MM/YYYY').format('YYYY-MM-DD');
          description_validity_period_date_picker.setDate(new_val);
        }
      });

      window.js_end_date_pikaday_instance = changes_take_effect_date_picker;

      this.initialCheckOfDescriptionBlock();

      $(document).on('click', ".js-create-measures-v1-submit-button, .js-workbasket-base-submit-button", function(e) {
        e.preventDefault();
        e.stopPropagation();

        submit_button = $(this);

        self.savedSuccessfully = false;
        WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));

        changes_take_effect__date = $(".js-changes_take_effect_date_input").val();
        description_validity_period__date = $(".js-description-validity-period-date").val();

        self.errors = {};
        self.conformanceErrors = {};

        $.ajax({
          url: window.save_url,
          type: "PUT",
          data: {
            step: window.current_step,
            mode: submit_button.attr('name'),
            settings: self.footnotePayLoad()
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

        setTimeout(function() {
          var start_date_formatted = '';
          if (changes_take_effect__date.length > 0) {
            $(".js-changes_take_effect_date_input").val(changes_take_effect__date);

            start_date_formatted = moment(changes_take_effect__date, 'DD/MM/YYYY').format('YYYY-MM-DD');
            changes_take_effect_date_picker.setDate(start_date_formatted);
          }

          var end_date_formatted = ''
          if (description_validity_period__date.length > 0) {
            $(".js-description-validity-period-date").val(description_validity_period__date);

            end_date_formatted = moment(description_validity_period__date, 'DD/MM/YYYY').format('YYYY-MM-DD');
            description_validity_period_date_picker.setDate(end_date_formatted);
          }
        }, 1000);
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
        if (newVal && newVal == window.__original_footnote_description) {
          this.hideDescriptionValidityStartDateBlock();
        } else {
          this.showDescriptionValidityStartDateBlock();
        }
      }
    },
    methods: {
      showDescriptionValidityStartDateBlock: function() {
        $(".edit-footnote-description-validity-period-block").removeClass('hidden');
        $(".js-validity-period-start-date-block").removeClass("without_top_margin");
      },
      hideDescriptionValidityStartDateBlock: function() {
        $(".edit-footnote-description-validity-period-block").addClass('hidden');
        $(".js-validity-period-start-date-block").addClass("without_top_margin");
      },
      initialCheckOfDescriptionBlock: function() {
        current_footnote_description = $(".js-footnote-description-textarea").val();

        if (current_footnote_description !== window.__original_footnote_description) {
          this.showDescriptionValidityStartDateBlock();
        } else {
          this.hideDescriptionValidityStartDateBlock();
        }
      },
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
      footnotePayLoad: function() {
        if ($(".js-footnote-description-textarea").val() !== window.__original_footnote_description) {
          description_validity_start_date = $(".js-description-validity-period-date").val();
        } else {
          description_validity_start_date = '';
        }

        return {
          reason_for_changes: this.footnote.reason_for_changes,
          description: this.footnote.description,
          operation_date: $(".js-changes_take_effect_date_input").val(),
          description_validity_start_date: description_validity_start_date,
          validity_start_date: this.footnote.validity_start_date,
          validity_end_date: this.footnote.validity_end_date,
          commodity_codes: this.footnote.commodity_codes,
          measure_sids: this.footnote.measure_sids
        };
      }
    }
  });
});
