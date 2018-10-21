$(document).ready(function() {
  var form = document.querySelector(".js-search-certificates-section");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        errors: {},
        errorsSummary: "",
        certificate_types_list: window.__certificate_types_list_json
      };

      if (!$.isEmptyObject(window.__search_certificates_settings_json)) {
        data.search = this.parseCertificateFormPayload(window.__search_certificates_settings_json);
      } else {
        data.search = this.emptyCertificateForm();
      }

      return data;
    },
    mounted: function() {
      var self = this;

      $(document).on('click', ".js-validate-certificate-search-form", function(e) {
        e.preventDefault();
        e.stopPropagation();

        WorkbasketSubmitSpinnerSupport.showSpinnerAndLockSubmissionButtons($(this));

        $.ajax({
          url: window.__validate_search_settings_url,
          type: "GET",
          data: {
            search: self.certificateFormPayload()
          },
          success: function(response) {
            self.errors = [];

            $(".js-search-certificate-form").submit();
          },
          error: function(response) {
            WorkbasketSubmitSpinnerSupport.hideSpinnerAndUnlockSubmissionButtons();

            if (response.status == 500) {
              alert("There was a server error which prevented the search to be performed. Please try again in a few moments.");
              return;
            }

            self.errorsSummary = response.responseJSON.errors.general_summary;
            self.errors = response.responseJSON.errors;
          }
        });

        DatepickerRangeMonkeyPatch.fix('search[start_date]', 'search[end_date]');
      });

      WorkbasketSearchResultsPaginationHelper.init();
    },
    computed: {
      hasErrors: function() {
        return Object.keys(this.errors).length > 0;
      }
    },
    methods: {
      parseCertificateFormPayload: function(payload) {
        return {
          certificate_type_code: payload.certificate_type_code,
          q: payload.q,
          start_date: payload.start_date,
          end_date: payload.end_date
        };
      },
      emptyCertificateForm: function() {
        return {
          certificate_type_code: null,
          q: null,
          start_date: null,
          end_date: null
        };
      },
      certificateFormPayload: function() {
        return {
          certificate_type_code: this.search.certificate_type_code,
          q: this.search.q,
          start_date: $('input[name=\'search[start_date]\']').val(),
          end_date: $('input[name=\'search[end_date]\']').val()
        };
      }
    }
  });
});
