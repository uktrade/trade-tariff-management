$(document).ready(function() {

  var form = document.querySelector(".create-additional-codes");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        workbasket_name: "",
        validity_start_date: "",
        validity_end_date: "",
        additional_codes: [],
        additional_code_types: [],
        savedSuccessfully: false,
        saving: false,
        submitting: false,
        errors: {},
        conformanceErrors: {},
        errorsSummary: ""
      };

      if (!$.isEmptyObject(window.all_settings)) {
        data.workbasket_name = window.all_settings.workbasket_name;
        data.validity_start_date = window.all_settings.validity_start_date;
        data.validity_end_date = window.all_settings.validity_end_date;
        data.additional_codes = objectToArray(window.all_settings.additional_codes);
      }

      return data;
    },
    mounted: function() {
      if (this.additional_codes.length === 0) {
        this.addAdditionalCodes();
      }
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
      addAdditionalCodes: function() {
        for( var i = 0; i < 5; i++) {
          this.additional_codes.push({
            additional_code_type_id: null,
            additional_code: "",
            description: ""
          });
        }
      },
      submitCrossCheck: function() {
        if (!this.validate("submit_for_cross_check")) {
          // focus to summary if errors, do not if only conformance errors
          if (this.hasErrors) {
            $(document).scrollTop($("#content").offset().top);
          }
          return;
        }

        var self = this;
        this.submitting = true;

        var success = function handleSuccess(response) {
          if (response.redirect_url) {
            window.location = response.redirect_url;
          }
        };

        var error = function handleError(response) {
          self.parseErrors("submit_for_cross_check", response.errors);
        };

        this.sendPayload("submit_for_cross_check", success.bind(this), error.bind(this));
      },
      sendPayload: function(action, success, error) {
        this.savedSuccessfully = false;

        var self = this;
        var payload = this.preparePayload();

        var data_ops = {
          step: window.current_step,
          mode: action,
          settings: payload
        };

        this.errors = {};
        this.conformanceErrors = {};

        $.ajax({
          url: window.save_url,
          type: "PUT",
          data: data_ops,
          success: function(response) {
            self.saving = false;
            self.submitting = false;
            self.savedSuccessfully = true;
            success(response);
          },
          error: function(response) {
            self.saving = false;
            self.submitting = false;

            if (response.status == 500) {
              alert("There was a server error which prevented the additional codes to be saved. Please try again in a few moments.");
              return;
            }

            try {
              if (!(response.errors.general.workbasket_name || response.errors.general.validity_start_date)) {
                self.savedSuccessfully = true;
              }
            } catch (e) {
              self.savedSuccessfully = true;
            }

            error(response.responseJSON);
          }
        });
      },
      preparePayload: function() {
        return {
          workbasket_name: this.workbasket_name,
          validity_start_date: this.validity_start_date,
          validity_end_date: this.validity_end_date,
          additional_codes: this.additional_codes
        }
      },
      saveProgress: function() {
        if (!this.validate("save_progress")) {
          return;
        }

        var self = this;
        this.saving = true;

        var success = function handleSuccess() {};

        var error = function handleError(response) {
          self.parseErrors("save_progress", response.errors);
        };

        this.sendPayload("save_progress", success.bind(this), error.bind(this));
      },
      validate: function(action) {
        var validator = new AdditionalCodesValidator(this);

        var results = validator.validate(action);
        this.errors = results.errors;
        this.errorsSummary = results.summary;

        return results.valid;
      },
      parseErrors: function(action, errors) {
        var validator = new AdditionalCodesValidator(this);

        var results = validator.parseBackendErrors(action, errors);
        this.errors = results.errors;
        this.conformanceErrors = validator.conformanceErrors;
        this.errorsSummary = results.summary;
        // focus to summary if errors, do not if only conformance errors
        if (this.hasErrors) {
          $(document).scrollTop($("#content").offset().top);
        }

        return results.valid;
      }
    }
  });
});
