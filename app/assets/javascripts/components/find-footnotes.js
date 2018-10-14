$(document).ready(function() {
  var form = document.querySelector(".js-search-footnotes-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        errors: {},
        errorsSummary: "",
        footnote_types_list: window.__footnote_types_list_json
      };

      if (!$.isEmptyObject(window.__search_footnotes_settings_json)) {
        data.search = this.parseFootnoteFormPayload(window.__search_footnotes_settings_json);
      } else {
        data.search = this.emptyFootnoteForm();
      }

      return data;
    },
    mounted: function() {
      var self = this;

      $(document).on('click', ".js-validate-footnotes-search-form", function(e) {
        e.preventDefault();
        e.stopPropagation();

        submit_button = $(this);

        //
        // FIX ME:
        // So this fix is temporary.
        // Issue is that when you call:
        //
        // self.errors = [SET ANY VALUE HERE];
        //
        // when start_date and end_date datepicker inputs
        // are refreshing to empty values.
        //
        var start_date = $("input[name='search[start_date]']").val();
        var start_date_formatted = '';
        if (start_date.length > 0) {
          start_date_formatted = moment(start_date, 'DD/MM/YYYY').format('YYYY-MM-DD');
        }

        var end_date = $("input[name='search[end_date]']").val();
        var end_date_formatted = '';
        if (end_date.length > 0) {
          end_date_formatted = moment(end_date, 'DD/MM/YYYY').format('YYYY-MM-DD');
        }

        WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));

        $.ajax({
          url: window.__validate_search_settings_url,
          type: "GET",
          data: {
            search: self.footnoteFormPayload()
          },
          success: function(response) {
            self.errors = [];
            WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();
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

        //
        // FIX ME:
        // So this fix is temporary.
        // Issue is that when you call:
        //
        // self.errors = [SET ANY VALUE HERE];
        //
        // when start_date and end_date datepicker inputs
        // are refreshing to empty values.
        //
        setTimeout(function fixdate() {
          if (start_date_formatted.length > 0) {
            window.js_start_date_pikaday_instance.setDate(start_date_formatted);
          }

          if (end_date_formatted.length > 0) {
            window.js_end_date_pikaday_instance.setDate(end_date_formatted);
          }
        }, 50);
      });
    },
    computed: {
      hasErrors: function() {
        return Object.keys(this.errors).length > 0;
      }
    },
    methods: {
      parseFootnoteFormPayload: function(payload) {
        return {
          footnote_type_id: payload.footnote_type_id,
          q: payload.q,
          commodity_codes: payload.commodity_codes,
          measure_sids: payload.measure_sids,
          start_date: payload.start_date,
          end_date: payload.end_date
        };
      },
      emptyFootnoteForm: function() {
        return {
          footnote_type_id: null,
          q: null,
          commodity_codes: null,
          measure_sids: null,
          start_date: null,
          end_date: null
        };
      },
      footnoteFormPayload: function() {
        return {
          footnote_type_id: this.search.footnote_type_id,
          q: this.search.q,
          commodity_codes: this.search.commodity_codes,
          measure_sids: this.search.measure_sids,
          start_date: this.search.start_date,
          end_date: this.search.end_date
        };
      }
    }
  });
});
