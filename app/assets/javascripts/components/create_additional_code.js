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
        errors: {},
        errorsSummary: ""
      };

      // parse saved payload

      return data;
    },
    mounted: function() {
      if (this.additional_codes.length === 0) {
        for( var i = 5; i--; ) {
          this.addAdditionalCode();
        }
      }
    },
    computed: {
      hasErrors: function() {
        return Object.keys(this.errors).length > 0;
      }
    },
    methods: {
      addAdditionalCode: function() {
        this.additional_codes.push({
          additional_code_type_id: null,
          additional_code: "",
          description: ""
        });
      },
      submitCrossCheck: function() {
        if (!this.validate("submit_for_cross_check")) {
          submit_button = $(this.$refs.submit_button);

          this.savedSuccessfully = false;
          WorkbasketBaseSaveActions.toogleSaveSpinner($(submit_button).attr('name'));
          var http_method = "PUT";

          var payload = this.preparePayload();

          var data_ops = {
            step: window.current_step,
            mode: submit_button.attr('name'),
            settings: payload
          };

          this.errors = [];

          console.log(window.save_url);

          $.ajax({
            url: window.save_url,
            type: http_method,
            data: data_ops,
            success: function(response) {
              WorkbasketBaseSaveActions.handleSuccessResponse(response, submit_button.attr('name'), function() {
                this.savedSuccessfully = true;
              });
            },
            error: function(response) {
              this.savedSuccessfully = true;
              WorkbasketBaseValidationErrorsHandler.handleErrorsResponse(response, this);
            }
          });
        }
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
