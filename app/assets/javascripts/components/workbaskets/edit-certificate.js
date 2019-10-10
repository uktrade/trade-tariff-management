$(document).ready(function() {
  var form = document.querySelector(".js-edit-certificate-form");

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

      if (!$.isEmptyObject(window.__certificate_json)) {
        data.certificate = this.parseCertificatePayload(window.__certificate_json);
      } else {
        data.certificate = this.emptyCertificate();
      }

      return data;
    },
    mounted: function() {
      var self = this;

      this.initialCheckOfDescriptionBlock();

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
            settings: self.certificatePayLoad()
          },
          success: function(response) {
            WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock();

            if (response.redirect_url !== undefined) {
              window.location = response.redirect_url;
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
            // focus to summary if errors, do not if only conformance errors
            if (self.hasErrors) {
              $(document).scrollTop($("#content").offset().top);
            }
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
      "certificate.description": function(newVal) {
        if (newVal && newVal == window.__original_certificate_description) {
          this.hideDescriptionValidityStartDateBlock();
        } else {
          this.showDescriptionValidityStartDateBlock();
        }
      }
    },
    methods: {
      showDescriptionValidityStartDateBlock: function() {
        $(".edit-certificate-description-validity-period-block").removeClass('hidden');
        $(".js-validity-period-start-date-block").removeClass("without_top_margin");
      },
      hideDescriptionValidityStartDateBlock: function() {
        $(".edit-certificate-description-validity-period-block").addClass('hidden');
        $(".js-validity-period-start-date-block").addClass("without_top_margin");
      },
      initialCheckOfDescriptionBlock: function() {
        current_certificate_description = $(".js-certificate-description-textarea").val();

        if (current_certificate_description !== window.__original_certificate_description) {
          this.showDescriptionValidityStartDateBlock();
        } else {
          this.hideDescriptionValidityStartDateBlock();
        }
      },
      parseCertificatePayload: function(payload) {
        return {
          reason_for_changes: payload.reason_for_changes,
          operation_date: payload.operation_date,
          description: payload.description,
          description_validity_start_date: payload.description_validity_start_date,
          validity_start_date: payload.validity_start_date,
          validity_end_date: payload.validity_end_date
        };
      },
      emptyCertificate: function() {
        return {
          reason_for_changes: null,
          operation_date: null,
          description: null,
          description_validity_start_date: null,
          validity_start_date: null,
          validity_end_date: null
        };
      },
      certificatePayLoad: function() {
        if ($(".js-certificate-description-textarea").val() !== window.__original_certificate_description) {
          description_validity_start_date = $("input[name='workbasket_forms_edit_certificate_form[description_validity_start_date]']").val();
        } else {
          description_validity_start_date = '';
        }

        return {
          reason_for_changes: this.certificate.reason_for_changes,
          description: this.certificate.description,
          operation_date: $(".js-changes_take_effect_date_input").val(),
          description_validity_start_date: description_validity_start_date,
          validity_start_date: this.certificate.validity_start_date,
          validity_end_date: this.certificate.validity_end_date
        };
      }
    }
  });
});
