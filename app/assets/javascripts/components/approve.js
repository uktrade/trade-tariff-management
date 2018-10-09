$(document).ready(function() {
  var form = document.querySelector(".approve-form");

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

      if (!$.isEmptyObject(window.__approve_json)) {
        data.approve = this.parseApprovePayload(window.__approve_json);

        if (data.approve.mode) {
          types[data.approve.mode]['selected'] = true;
        }
      } else {
        data.approve = this.emptyApprove();
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
              approve: self.crossCheckPayLoad()
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
      parseApprovePayload: function(payload) {
        return {
          mode: payload.mode,
          submit_for_approval: payload.submit_for_approval,
          reject_reasons: payload.reject_reasons,
          export_date: payload.export_date
        };
      },
      emptyApprove: function() {
        return {
          mode: null,
          submit_for_approval: null,
          reject_reasons: null,
          export_date: null
        };
      },
      crossCheckPayLoad: function() {
        mode = $("input[name='approve[mode]']").val();

        if (mode.length > 0 && mode == 'on') {
          mode = '';
        }

        return {
          mode: mode,
          submit_for_approval: $("input[name='approve[submit_for_approval]']").val(),
          reject_reasons: $("textarea[name='approve[reject_reasons]']").val(),
          export_date: $("input[name='approve[export_date]']").val()
        };
      }
    }
  });
});
