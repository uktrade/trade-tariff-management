$(document).ready(function() {
  var form = document.querySelector(".js-search-geographical-areas-section");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        errors: {},
        errorsSummary: ""
      };

      if (!$.isEmptyObject(window.__search_geo_areas_settings_json)) {
        data.search = this.parseGeoAreaFormPayload(window.__search_geo_areas_settings_json);
      } else {
        data.search = this.emptyGeoAreaForm();
      }

      return data;
    },
    mounted: function() {
      var self = this;

      $(document).on('click', ".js-validate-geographical-areas-search-form", function(e) {
        e.preventDefault();
        e.stopPropagation();

        submit_button = $(this);
        WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));

        $.ajax({
          url: window.__validate_search_settings_url,
          type: "GET",
          data: {
            search: self.geoAreaFormPayload()
          },
          success: function(response) {
            self.errors = [];
            WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();

            $(".js-search-geographical-areas-form").submit();
          },
          error: function(response) {
            WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();

            if (response.status == 500) {
              alert("There was a server error which prevented the search to be performed. Please try again in a few moments.");
              return;
            }

            self.errorsSummary = response.responseJSON.errors.general_summary;
            self.errors = response.responseJSON.errors;
          }
        });

        DatepickerRangeMonkeyPatch.fix();
      });
    },
    computed: {
      hasErrors: function() {
        return Object.keys(this.errors).length > 0;
      }
    },
    methods: {
      parseGeoAreaFormPayload: function(payload) {
        return {
          q: payload.q,
          start_date: payload.start_date,
          end_date: payload.end_date,
          code_country: payload.code_country,
          code_region: payload.code_region,
          code_group: payload.code_group
        };
      },
      emptyGeoAreaForm: function() {
        return {
          q: null,
          start_date: null,
          end_date: null,
          code_country: null,
          code_region: null,
          code_group: null
        };
      },
      geoAreaFormPayload: function() {
        return {
          q: this.search.q,
          start_date: $('input[name=\'search[start_date]\']').val(),
          end_date: $('input[name=\'search[end_date]\']').val(),
          code_country: this.search.code_country,
          code_region: this.search.code_region,
          code_group: this.search.code_group
        };
      }
    }
  });
});
