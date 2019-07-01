$(document).ready(function() {
  var form = document.querySelector(".js-edit-geographical_area-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        groups_list: window.__geographical_area_groups_json,
        savedSuccessfully: false,
        errors: {},
        conformanceErrors: {},
        errorsSummary: "",
        addingMembers: false,
        addingToGroups: false,
        editingMembership: null,
        sortBy: "geographical_area_id",
        sortDir: "desc",
        parentGroupsList: window.__geographical_area_groups_json,
        removed_memberships: []
      };

      if (!$.isEmptyObject(window.__geographical_area_json)) {
        data.geographical_area = this.parseGeographicalAreaPayload(window.__geographical_area_json);

        area_code = data.geographical_area.geographical_code;

        // disable radio buttons
        $(".radio-inline-group").attr('disabled', 'disabled');

        if (area_code.length > 0) {
          radion_button = $(".geographical-area-type .multiple-choice[data-type-value='" + area_code + "'] input");
          radion_button.attr('checked', true);
        }
      } else {
        data.geographical_area = this.emptyGeographicalArea();
      }

      return data;
    },
    mounted: function() {
      var self = this;

      var description_validity_period_date_input = $(".js-description-validity-period-date");

      var description_validity_period_date_picker = new Pikaday({
        field: description_validity_period_date_input[0],
        format: "DD/MM/YYYY",
        blurFieldOnSelect: true,
        onSelect: function(value) {
          description_validity_period_date_input.trigger("change");
        }
      });

      window.js_start_date_pikaday_instance = description_validity_period_date_picker;

      var changes_take_effect_date_input = $(".js-changes_take_effect_date_input");

      var changes_take_effect_date_picker = new Pikaday({
        field: changes_take_effect_date_input[0],
        format: "DD/MM/YYYY",
        blurFieldOnSelect: true,
        onSelect: function(value) {
          changes_take_effect_date_input.trigger("change");
          new_val = moment(changes_take_effect_date_input.val(), 'DD/MM/YYYY').format('YYYY-MM-DD');
          description_validity_period_date_picker.setDate(new_val);
        }
      });

      window.js_end_date_pikaday_instance = changes_take_effect_date_picker;

      this.initialCheckOfDescriptionBlock();

      $(document).on('click', ".js-create-measures-v1-submit-button, .js-workbasket-base-submit-button", function(e) {
        e.preventDefault();
        e.stopPropagation();

        submit_button = $(this);

        self.savedSuccessfully = false;
        WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));

        changes_take_effect__date = $(".js-changes_take_effect_date_input").val();
        description_validity_period__date = $(".js-description-validity-period-date").val();

        self.errors = {};
        self.conformanceErrors = {};

        $.ajax({
          url: window.save_url,
          type: "PUT",
          data: {
            step: window.current_step,
            mode: submit_button.attr('name'),
            settings: self.geographicalAreaPayLoad()
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
          }
        });

        setTimeout(function() {
          var start_date_formatted = '';
          if (changes_take_effect__date.length > 0) {
            $(".js-changes_take_effect_date_input").val(changes_take_effect__date);

            start_date_formatted = moment(changes_take_effect__date, 'DD/MM/YYYY').format('YYYY-MM-DD');
            changes_take_effect_date_picker.setDate(start_date_formatted);
          }

          var end_date_formatted = ''
          if (description_validity_period__date.length > 0) {
            $(".js-description-validity-period-date").val(description_validity_period__date);

            end_date_formatted = moment(description_validity_period__date, 'DD/MM/YYYY').format('YYYY-MM-DD');
            description_validity_period_date_picker.setDate(end_date_formatted);
          }
        }, 1000);
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
        return (this.geographical_area.geographical_code === 'group' || this.geographical_area.geographical_code === '1');
      },
      isRegion: function() {
        return (this.geographical_area.geographical_code === 'region' || this.geographical_area.geographical_code === '2');
      },
      isCountry: function() {
        return (this.geographical_area.geographical_code === 'country' || this.geographical_area.geographical_code === '0');
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
      "geographical_area.description": function(newVal) {
        if (newVal && newVal == window.__original_geographical_area_description) {
          this.hideDescriptionValidityStartDateBlock();
        } else {
          this.showDescriptionValidityStartDateBlock();
        }
      },
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
      showDescriptionValidityStartDateBlock: function() {
        $(".edit-geographical_area-description-validity-period-block").removeClass('hidden');
        $(".js-validity-period-start-date-block").removeClass("without_top_margin");
      },
      hideDescriptionValidityStartDateBlock: function() {
        $(".edit-geographical_area-description-validity-period-block").addClass('hidden');
        $(".js-validity-period-start-date-block").addClass("without_top_margin");
      },
      initialCheckOfDescriptionBlock: function() {
        current_geographical_area_description = $(".js-geographical_area-description-textarea").val();

        if (current_geographical_area_description !== window.__original_geographical_area_description) {
          this.showDescriptionValidityStartDateBlock();
        } else {
          this.hideDescriptionValidityStartDateBlock();
        }
      },
      parseGeographicalAreaPayload: function(payload) {
        let operation_date = payload.operation_date || moment(new Date()).format('DD/MM/YYYY');
        return {
          geographical_code: payload.geographical_code,
          geographical_area_id: payload.geographical_area_id,
          reason_for_changes: payload.reason_for_changes,
          operation_date: operation_date,
          description: payload.description,
          description_validity_start_date: payload.description_validity_start_date,
          parent_geographical_area_group_id: payload.parent_geographical_area_group_id,
          validity_start_date: payload.validity_start_date,
          validity_end_date: payload.validity_end_date,
          remove_parent_group_association: payload.remove_parent_group_association,
          geographical_area_memberships: payload.geographical_area_memberships
        };
      },
      emptyGeographicalArea: function() {
        return {
          geographical_code: null,
          geographical_area_id: null,
          reason_for_changes: null,
          operation_date: null,
          description: null,
          description_validity_start_date: null,
          parent_geographical_area_group_id: null,
          validity_start_date: null,
          validity_end_date: null,
          remove_parent_group_association: null
        };
      },
      geographicalAreaPayLoad: function() {
        if ($(".js-geographical_area-description-textarea").val() !== window.__original_geographical_area_description) {
          description_validity_start_date = $(".js-description-validity-period-date").val();
        } else {
          description_validity_start_date = '';
        }

        if ($("input[name='geographical_area[remove_parent_group_association]']").prop('checked')) {
          remove_parent_group_association = true;
        } else {
          remove_parent_group_association = '';
        }

        return {
          reason_for_changes: this.geographical_area.reason_for_changes,
          description: this.geographical_area.description,
          operation_date: $(".js-changes_take_effect_date_input").val(),
          description_validity_start_date: description_validity_start_date,
          parent_geographical_area_group_id: $("select[name='geographical_area[parent_geographical_area_group_id]']").val(),
          validity_start_date: this.geographical_area.validity_start_date,
          validity_end_date: this.geographical_area.validity_end_date,
          remove_parent_group_association: remove_parent_group_association,
          geographical_area_memberships: this.geographical_area.geographical_area_memberships,
          removed_memberships: this.removed_memberships,
        };
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
      },
      removeMembership: function(membership) {
        var ids = this.geographical_area.geographical_area_memberships.map( m => m.geographical_area_id )

        var index = ids.indexOf(membership.geographical_area_id)
        if (index !== -1) {
          this.removed_memberships.push(this.geographical_area.geographical_area_memberships[index])
          this.geographical_area.geographical_area_memberships.splice(index, 1);
        }
      },
    }
  });
});
