$(document).ready(function() {
  var form = document.querySelector(".regulation-form");

  if (!form) {
    return;
  }

  const SUB_FIELD_LEGAL_ID = 0,
        SUB_FIELD_URL = 1,
        SUB_FIELD_DESCRIPTION = 2

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        savedSuccessfully: false,
        errors: window.__registration_errors || {}
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

          self.errors = {};

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

              // focus to summary if errors
              $(document).scrollTop($("#content").offset().top);
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
      parseRegulationPayload: function(payload) {
        return {
          abrogation_date: payload.abrogation_date,
          antidumping_regulation_role: payload.antidumping_regulation_role,
          base_regulation_id: payload.base_regulation_id,
          base_regulation_role: payload.base_regulation_role,
          community_code: payload.community_code,
          description: this.extract_sub_field(payload.information_text, SUB_FIELD_DESCRIPTION),
          effective_end_date: payload.effective_end_date,
          information_text: payload.information_text,
          legal_id: this.extract_sub_field(payload.information_text, SUB_FIELD_LEGAL_ID),
          number_suffix: payload.number_suffix,
          officialjournal_number: payload.officialjournal_number,
          officialjournal_page: payload.officialjournal_page,
          prefix: payload.prefix,
          publication_year: payload.publication_year,
          published_date: payload.published_date,
          reference_url: this.extract_sub_field(payload.information_text, SUB_FIELD_URL),
          regulation_group_id: payload.regulation_group_id,
          regulation_number: payload.regulation_number,
          related_antidumping_regulation_id: payload.related_antidumping_regulation_id,
          replacement_indicator: payload.replacement_indicator,
          role: payload.role ? payload.role + "" : payload.role,
          start_date: payload.start_date,
          validity_end_date: payload.end_date,
          validity_start_date: payload.start_date,
        };
      },
      emptyRegulation: function() {
        return {
          abrogation_date: null,
          antidumping_regulation_role: null,
          base_regulation_id: null,
          base_regulation_role: null,
          community_code: null,
          description: null,
          effective_end_date: null,
          information_text: null,
          legal_id: null,
          number_suffix: null,
          officialjournal_number: null,
          officialjournal_page: null,
          operation_date: new Date().toLocaleDateString("en-GB"),
          prefix: null,
          publication_year: null,
          published_date: null,
          reference_url: null,
          regulation_group_id: null,
          regulation_number: null,
          related_antidumping_regulation_id: null,
          replacement_indicator: "0",
          role: "1",
          start_date: null,
          validity_end_date: null,
          validity_start_date: null,
        }
      },
      createRegulationMainStepPayLoad: function() {
        return {
          abrogation_date: this.regulation.abrogation_date,
          antidumping_regulation_role: this.regulation.antidumping_regulation_role,
          base_regulation_id: this.regulation.base_regulation_id,
          base_regulation_role: this.regulation.base_regulation_role,
          community_code: this.regulation.community_code,
          effective_end_date: this.regulation.effective_end_date,
          end_date: this.regulation.validity_end_date,
          information_text: (this.regulation.legal_id || '') + '|' + (this.regulation.description || '') + '|' + (this.regulation.reference_url || ''),
          number_suffix: this.regulation.number_suffix,
          officialjournal_number: this.regulation.officialjournal_number,
          officialjournal_page: this.regulation.officialjournal_page,
          operation_date: this.regulation.operation_date || new Date().toLocaleDateString("en-GB"),
          prefix: this.regulation.prefix,
          publication_year: this.regulation.publication_year,
          published_date: this.regulation.published_date,
          regulation_group_id: this.regulation.regulation_group_id,
          regulation_number: this.regulation.regulation_number,
          related_antidumping_regulation_id: this.regulation.related_antidumping_regulation_id,
          replacement_indicator: this.regulation.replacement_indicator,
          role: "1",
          start_date: this.regulation.validity_start_date,
          validity_end_date: this.regulation.validity_end_date,
          validity_start_date: this.regulation.validity_start_date,
        };
      },
      extract_sub_field: function(string, field_position){
        if (string === undefined) {
          return undefined
        }
        return string.split("|")[field_position]
      }
    }
  });
});
