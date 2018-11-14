$(document).ready(function() {

  var form = document.querySelector(".work-with-selected-quota");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      return {
        regulation: null,
        regulation_id: null,
        regulation_role: null,
        changesNotFromLegislation: false,
        validity_start_date: null,
        reason: "",
        workbasket_name: "",
        action: null,
        suspension_date: null,
        errors: {},
        errorsSummary: "",
        hasErrors: false
      };
    },
    computed: {
      disableSubmit: function() {
        return !this.action;
      },
      suspendingQuota: function() {
        return this.action === "suspend_quota";
      },
      buttonText: function() {
        if (this.action === "edit_quota") {
          return "Proceed to selected quota";
        } else if (this.action === "edit_quota_measures") {
          return "Proceed to selected quota measures";
        }

        return "Submit for cross-check";
      }
    },
    methods: {
      regulationSelected: function(obj) {
        this.regulation_id = obj.regulation_id;
        this.regulation_role = obj.role;
        this.regulation = obj.regulation;
      },
      validate: function(e) {
        var continueActions = ["edit_quota", "edit_quota_measures"];
        var action = continueActions.indexOf(this.action) > -1 ? "continue" : "submit_for_cross_check";

        var validator = new WorkWithSelectedQuotaValidator(this);
        var result = validator.validate(action);

        if (!result.valid) {
          e.preventDefault();
        }

        this.hasErrors = !result.valid;
        this.errors = result.errors;
        this.errorsSummary = result.summary;
      }
    },
    watch: {
      changesNotFromLegislation: function(val) {
        if (val) {
          this.regulation_id = null;
          this.regulation_role = null;
        }
      }
    }
  });
});
