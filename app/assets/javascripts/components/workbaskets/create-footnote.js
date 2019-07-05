$(document).ready(function() {
  var form = document.querySelector(".js-create-footnote-form");

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

      data.footnote_types_list = window.__footnote_types_list_json;

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
              settings: self.createFootnoteMainStepPayLoad()
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
      },
      showAssociations: function() {
        var ft_id = this.footnote.footnote_type_id;

        if (ft_id !== null && ft_id.length > 0) {
          return $.inArray( ft_id.toString(), window.__goods_and_measures_footnote_type_ids_json ) !== -1;
        } else {
          return false;
        }
      },
      showGoodsClassificationCodes: function() {
        var ft_id = this.footnote.footnote_type_id;

        if (ft_id !== null && ft_id.length > 0) {
          return $.inArray( ft_id.toString(), window.__goods_footnote_type_ids_json ) !== -1;
        } else {
          return false;
        }
      },
      showMeasures: function() {
        var ft_id = this.footnote.footnote_type_id;

        if (ft_id !== null && ft_id.length > 0) {
          return $.inArray( ft_id.toString(), window.__measures_footnote_type_ids_json ) !== -1;
        } else {
          return false;
        }
      }
    },
    methods: {
      parseFootnotePayload: function(payload) {
        return {
          footnote_type_id: payload.footnote_type_id,
          description: payload.description,
          validity_start_date: payload.validity_start_date,
          validity_end_date: payload.validity_end_date,
          commodity_codes: payload.commodity_codes,
          measure_sids: payload.measure_sids,
          operation_date: payload.operation_date
        };
      },
      emptyFootnote: function() {
        return {
          footnote_type_id: null,
          description: null,
          validity_start_date: null,
          validity_end_date: null,
          commodity_codes: null,
          measure_sids: null,
          operation_date: null
        };
      },
      createFootnoteMainStepPayLoad: function() {
        return {
          footnote_type_id: this.footnote.footnote_type_id,
          description: this.footnote.description,
          validity_start_date: this.footnote.validity_start_date,
          validity_end_date: this.footnote.validity_end_date,
          commodity_codes: this.footnote.commodity_codes,
          measure_sids: this.footnote.measure_sids,
          operation_date: this.footnote.operation_date
        };
      }
    }
  });
});
