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
        errorsSummary: ""
      };

      // parse saved payload

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
        // if (!this.validate("submit_for_cross_check")) {
        //   return;
        // }

        this.submitting = true;

        var success = function handleSuccess(response) {
          if (response.redirect_url) {
            window.location = response.redirect_url;
          }
        };

        var error = function handleError(response) {
          console.log(response);
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

        this.errors = [];

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

            self.savedSuccessfully = true;
            error(response);
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
        // if (!this.validate("save_progress")) {
        //   return;
        // }

        this.saving = true;

        var success = function handleSuccess() {};

        var error = function handleError(response) {
          console.log(response);
        };

        this.sendPayload("save_progress", success.bind(this), error.bind(this));
      },
      validate: function(action) {
        var validator = new AdditionalCodesValidator(this);

        var results = validator.validate(action);
        this.errors = results.errors;
        this.errorsSummary = results.summary;

        return results.valid;
      }
    }
  });
});
