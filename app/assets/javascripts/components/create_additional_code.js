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
        this.addAdditionalCode();
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
          return;
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
