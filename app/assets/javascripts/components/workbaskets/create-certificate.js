$(document).ready(function() {
  var form = document.querySelector(".js-create-certificate-form");

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

      data.certificate_types_list = window.__certificate_types_list_json;

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
              settings: self.createCertificateMainStepPayLoad()
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
              // focus to summary if errors, do not if only conformance errors
              if (self.hasErrors) {
                $(document).scrollTop($("#content").offset().top);
              }
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
      parseCertificatePayload: function(payload) {
        return {
          certificate_type_code: payload.certificate_type_code,
          certificate_code: payload.certificate_code,
          description: payload.description,
          validity_start_date: payload.validity_start_date,
          validity_end_date: payload.validity_end_date,
          operation_date: payload.operation_date
        };
      },
      emptyCertificate: function() {
        return {
          certificate_type_code: null,
          certificate_code: null,
          description: null,
          validity_start_date: null,
          validity_end_date: null,
          operation_date: null
        };
      },
      createCertificateMainStepPayLoad: function() {
        return {
          certificate_type_code: this.certificate.certificate_type_code,
          certificate_code: this.certificate.certificate_code,
          description: this.certificate.description,
          validity_start_date: this.certificate.validity_start_date,
          validity_end_date: this.certificate.validity_end_date,
          operation_date: this.certificate.operation_date
        };
      }
    }
  });
});
