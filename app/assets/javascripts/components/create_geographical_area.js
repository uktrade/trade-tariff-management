$(document).ready(function() {
  var form = document.querySelector(".geographical-area-form");

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
        errorsSummary: "",
        addingMembers: false,
        addingToGroups: false,
        editingMembership: null,
        sortBy: "geographical_area_id",
        sortDir: "desc",
        parentGroupsList: window.__geographical_area_groups_json
      };

      if (!$.isEmptyObject(window.__geographical_area_json)) {
        data.geographical_area = this.parseGeographicalAreaPayload(window.__geographical_area_json);
      } else {
        data.geographical_area = this.emptyGeographicalArea();
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
          self.errors = [];

          $.ajax({
            url: window.save_url,
            type: "PUT",
            data: {
              step: window.current_step,
              mode: submit_button.attr('name'),
              settings: self.createGeographicalAreaMainStepPayLoad()
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

              self.errorsSummary = "All bad guys!";
              self.errors = response.responseJSON.errors;
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
      isGroup: function() {
        return this.geographical_area.geographical_code === 'group';
      },
      isRegion: function() {
        return this.geographical_area.geographical_code === 'region';
      },
      isCountry: function() {
        return this.geographical_area.geographical_code === 'country';
      },
      sortedMemberships: function() {
        var memberships = this.geographical_area.geographical_area_memberships.slice(0);
        var sortBy = this.sortBy;
        var sortDir = this.sortDir;

        memberships.sort(function(a, b) {
          if (sortBy == "geographical_area_id") {
            a = a[sortBy];
            b = b[sortBy];

            if (a == null || a == "-") {
              return -1;
            }

            if (b == null || b == "-") {
              return 1;
            }

            return ('' + a).localeCompare(b);
          } else {
            a = a[sortBy];
            b = b[sortBy];

            if (a == null || a == "-") {
              return -1;
            }

            if (b == null || b == "-") {
              return 1;
            }

            return moment(a, "DD MMM YYYY", true).diff(moment(b, "DD MMM YYYY", true), "days");
          }
        });

        if (sortDir === "desc") {
          memberships.reverse();
        }

        return memberships;
      }
    },
    watch: {
      "geographical_area.geographical_code": function(val, oldVal) {
        this.geographical_area.geographical_area_memberships = [];

        if (val == "country" || val == "region") {
          var ergaOmnes = this.findGeographicalArea("1011");
          var thirdCountries = this.findGeographicalArea("1008");

          this.geographical_area.geographical_area_memberships.push({
            geographical_area: ergaOmnes,
            geographical_area_id: ergaOmnes.geographical_area_id,
            geographical_area_group_sid: this.geographical_area.geographical_area_id,
            validity_start_date: this.join_date,
            validity_end_date: this.leave_date
          });

          this.geographical_area.geographical_area_memberships.push({
            geographical_area: thirdCountries,
            geographical_area_id: thirdCountries.geographical_area_id,
            geographical_area_group_sid: this.geographical_area.geographical_area_id,
            validity_start_date: this.join_date,
            validity_end_date: this.leave_date
          });
        }
      }
    },
    methods: {
      parseGeographicalAreaPayload: function(payload) {
        payload.geographical_area_memberships = objectToArray(payload.geographical_area_memberships);

        return payload;
      },
      emptyGeographicalArea: function() {
        return {
          geographical_code: null,
          geographical_area_id: null,
          parent_geographical_area_group_id: null,
          description: null,
          validity_start_date: null,
          validity_end_date: null,
          operation_date: null,
          geographical_area_memberships: []
        }
      },
      createGeographicalAreaMainStepPayLoad: function() {
        return this.geographical_area;
      },
      triggerAddMemberships: function() {
        if (this.isGroup) {
          this.addingMembers = true;
        } else {
          this.addingToGroups = true;
        }
      },
      closePopups: function() {
        this.addingMembers = false;
        this.addingToGroups = false;
        this.editingMembership = null;
      },
      findGeographicalArea: function(code) {
        var ids = window.__geographical_area_groups_json.map(function(m) {
          return m.geographical_area_id;
        });

        var index = ids.indexOf(code);

        if (index === -1) {
          return;
        }

        return window.__geographical_area_groups_json[index];
      },
      changeSorting: function(field) {
        if (field !== this.sortBy) {
          this.sortDir = "desc";
        } else {
          this.sortDir = this.sortDir == "desc" ? "asc" : "desc";
        }

        this.sortBy = field;
      },
      editMembership: function(membership) {
        this.editingMembership = membership;
      }
    }
  });
});
