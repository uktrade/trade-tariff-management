$(document).ready(function() {
  var form = document.querySelector(".js-search-geographical-areas-form");

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
        data.geographical_area = this.parseGeoAreaFormPayload(window.__search_geo_areas_settings_json);
      } else {
        data.geographical_area = this.emptyGeoAreaForm();
      }

      return data;
    },
    mounted: function() {
      var self = this;

      $(document).on('click', ".js-validate-geographical-areas-search-form", function(e) {
        submit_button = $(this);

        WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));
        self.errors = [];

        console.log('------STARTING AJAX-----');

        $.ajax({
          url: window.validate_search_settings_url,
          type: "GET",
          data: {
            search: self.geoAreaFormPayload()
          },
          success: function(response) {
            console.log('------SUCCESS-----');

            WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();
          },
          error: function(response) {
            console.log('------ERRORS-----');

            WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();

            if (response.status == 500) {
              alert("There was a server error which prevented the search to be performed. Please try again in a few moments.");
              return;
            }

            self.errorsSummary = "All bad guys!";

            console.dir(response.responseJSON.errors);

            self.errors = response.responseJSON.errors;
          }
        });
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
          code: payload.code
        };
      },
      emptyGeoAreaForm: function() {
        return {
          q: null,
          start_date: null,
          end_date: null,
          code: null
        };
      },
      geoAreaFormPayload: function() {
        return {
          q: this.geographical_area.q,
          start_date: this.geographical_area.start_date,
          end_date: this.geographical_area.end_date,
          code: this.geographical_area.code
        };
      }
    }
  });
});
