$(document).ready(function() {
  var form = document.querySelector(".cross-check-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        savedSuccessfully: false,
        errors: {}
      };

      var types = {
        approve: {
          selected: false
        },
        reject: {
          selected: false
        }
      }

      if (!$.isEmptyObject(window.__cross_check_json)) {
        data.cross_check = this.parseCrossCheckPayload(window.__cross_check_json);

        if (data.cross_check.mode) {
          types[data.cross_check.mode]['selected'] = true;
        }
      } else {
        data.cross_check = this.emptyCrossCheck();
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

          self.savedSuccessfully = false;
          WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));
          self.errors = [];

          $.ajax({
            url: window.save_url,
            type: "POST",
            data: {
              cross_check: self.crossCheckPayLoad()
            },
            success: function(response) {
              WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock();

              if (response.redirect_url !== undefined) {
                setTimeout(function tick() {
                  window.location = resp.redirect_url;
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

              self.errors = response.responseJSON.errors;
            }
          });
        });
      });
    },
    computed: {
      hasErrors: function() {
        return Object.keys(this.errors).length > 0;
      }
    },
    methods: {
      parseCrossCheckPayload: function(payload) {
        return {
          mode: payload.mode,
          submit_for_approval: payload.submit_for_approval,
          reject_reasons: payload.reject_reasons
        };
      },
      emptyCrossCheck: function() {
        return {
          mode: null,
          submit_for_approval: null,
          reject_reasons: null
        };
      },
      crossCheckPayLoad: function() {
        mode = $("input[name='cross_check[mode]']").val();

        if (mode.length > 0 && mode == 'on') {
          mode = '';
        }

        return {
          mode: mode,
          submit_for_approval: $("input[name='cross_check[submit_for_approval]']").val(),
          reject_reasons: $("textarea[name='cross_check[reject_reasons]']").val()
        };
      }
    }
  });
});
