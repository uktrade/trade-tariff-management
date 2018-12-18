$(document).ready(function() {
  var form = document.querySelector(".regulation-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        savedSuccessfully: false,
        errors: []
      };

      if (window.__regulation_json) {
        data.regulation = this.parseRegulationPayload(window.__regulation_json);
      } else {
        data.regulation = this.emptyRegulation();
      }

      if (!data.regulation.replacement_indicator) {
        data.regulation.replacement_indicator = "0";
      }

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
          var http_method = "PUT";

          if (window.current_step == 'main') {
            var payload = self.createRegulationMainStepPayLoad();
          }

          self.errors = [];

          $.ajax({
            url: window.save_url,
            type: http_method,
            data: {
              step: window.current_step,
              mode: submit_button.attr('name'),
              settings: payload
            },
            success: function(response) {
              if ( $('input[type=file]').val() && $('input[type=file]').val().length > 0 ) {
                var formData = new FormData($("form.regulation-form")[0])
                formData.append('image', $('input[type=file]')[0].files[0]);

                $.ajax({
                  url: $("form.regulation-form").data('attach-pdf-url'),
                  data: formData,
                  type: http_method,
                  contentType: false,
                  processData: false,
                  success: function(resp) {
                    WorkbasketBaseSaveActions.handleSuccessResponse(response, submit_button.attr('name'), function() {
                      self.savedSuccessfully = true;
                    });
                  }
                });

              } else {
                WorkbasketBaseSaveActions.handleSuccessResponse(response, submit_button.attr('name'), function() {
                  self.savedSuccessfully = true;
                });
              }
            },
            error: function(response) {
              WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock();
              self.errors = response.responseJSON.errors;
              WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();
            }
          });
        });
      });
    },
    computed: {
      hasErrors: function() {
        return this.errors.length > 0;
      }
    },
    methods: {
      parseRegulationPayload: function(payload) {
        //Todo check which of these values are no longer necessary if we are using base regulations only
        return {
          role: payload.role ? payload.role + "" : payload.role,
          prefix: payload.prefix,
          publication_year: payload.publication_year,
          regulation_number: payload.regulation_number,
          number_suffix: payload.number_suffix,
          information_text: payload.information_text,
          effective_end_date: payload.effective_end_date,
          regulation_group_id: payload.regulation_group_id,
          base_regulation_id: payload.base_regulation_id,
          base_regulation_role: payload.base_regulation_role,
          replacement_indicator: payload.replacement_indicator,
          community_code: payload.community_code,
          officialjournal_number: payload.officialjournal_number,
          officialjournal_page: payload.officialjournal_page,
          antidumping_regulation_role: payload.antidumping_regulation_role,
          related_antidumping_regulation_id: payload.related_antidumping_regulation_id,
          published_date: payload.published_date,
          abrogation_date: payload.abrogation_date
        };
      },
      emptyRegulation: function() {
        return {
          //Todo check which of these values are no longer necessary if we are using base regulations only
          role: "1",
          prefix: null,
          publication_year: null,
          regulation_number: null,
          number_suffix: null,
          information_text: null,
          validity_start_date: null,
          validity_end_date: null,
          effective_end_date: null,
          regulation_group_id: null,
          base_regulation_id: null,
          base_regulation_role: null,
          replacement_indicator: "0",
          community_code: null,
          officialjournal_number: null,
          officialjournal_page: null,
          antidumping_regulation_role: null,
          related_antidumping_regulation_id: null,
          published_date: null,
          operation_date: null,
          abrogation_date: null
        }
      },
      createRegulationMainStepPayLoad: function() {
        return {
          //Todo check which of these values are no longer necessary if we are using base regulations only
          role: "1",
          prefix: this.regulation.prefix,
          publication_year: this.regulation.publication_year,
          regulation_number: this.regulation.regulation_number,
          number_suffix: this.regulation.number_suffix,
          information_text: this.regulation.information_text,
          effective_end_date: this.regulation.effective_end_date,
          regulation_group_id: this.regulation.regulation_group_id,
          base_regulation_id: this.regulation.base_regulation_id,
          base_regulation_role: this.regulation.base_regulation_role,
          replacement_indicator: this.regulation.replacement_indicator,
          community_code: this.regulation.community_code,
          officialjournal_number: this.regulation.officialjournal_number,
          officialjournal_page: this.regulation.officialjournal_page,
          antidumping_regulation_role: this.regulation.antidumping_regulation_role,
          related_antidumping_regulation_id: this.regulation.related_antidumping_regulation_id,
          start_date: this.regulation.validity_start_date,
          validity_start_date: this.regulation.validity_start_date,
          end_date: this.regulation.validity_end_date,
          validity_end_date: this.regulation.validity_end_date,
          operation_date: this.regulation.operation_date,
          published_date: this.regulation.published_date,
          abrogation_date: this.regulation.abrogation_date
        };
      }
    }
  });
});
