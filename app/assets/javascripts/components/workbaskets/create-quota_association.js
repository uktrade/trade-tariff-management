$(document).ready(function() {
  var form = document.querySelector("#vue-create-quota-association-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: {
      savedSuccessfully: false,
      errors: {},
      errorsSummary: "",
      quotaAssociation: {
        workbasket_name: null,
        parent_quota: null,
        child_quota: null,
        parent_definition_period: "",
        child_definition_period: "",
        relation_type: null,
        coefficient: null,
      },
    },
    computed: {
      hasErrors: function() {
        return Object.keys(this.errors).length > 0;
      },
    },
    created: function () {
      if (!$.isEmptyObject(window.__quota_association_json)) {
        this.quotaAssociation = this.parseData(window.__quota_association_json);
      }
    },
    mounted: function() {
      var self = this;

      if (sessionStorage.quota_association) {
        this.quotaAssociation = JSON.parse(sessionStorage.quota_association);
      }

      // All this will be moved to a proper place ....

      // $(document).ready(function(){
      //   $(document).on('click', ".js-workbasket-base-submit-button", function(e) {
      //     e.preventDefault();
      //     e.stopPropagation();

      //     submit_button = $(this);

      //     self.savedSuccessfully = false;
      //     WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));

      //     self.errors = {};
      //     self.conformanceErrors = {};

      //     $.ajax({
      //       url: window.save_url,
      //       type: "PUT",
      //       data: {
      //         step: window.current_step,
      //         mode: submit_button.attr('name'),
      //         settings: self.quotaAssociation
      //       },
      //       success: function(response) {
      //         WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock();

      //         if (response.redirect_url !== undefined) {
      //           setTimeout(function tick() {
      //             window.location = response.redirect_url;
      //           }, 1000);

      //         } else {
      //           WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();
      //           self.savedSuccessfully = true;
      //         }
      //       },
      //       error: function(response) {
      //         WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock();
      //         WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();

      //         if (response.status == 500) {
      //           alert("There was a server error which prevented the quota association to be saved. Please try again in a few moments.");
      //           return;
      //         }

      //         json_resp = response.responseJSON;
      //         self.errorsSummary = json_resp.errors_summary;
      //         self.errors = json_resp.errors;

      //         if (self.hasErrors) {
      //           $(document).scrollTop($("#content").offset().top);
      //         }
      //       }
      //     });
      //   });
      // });
    },
    watch: {
      quotaAssociation: {
        handler: function (after, before) {
          this.quotaAssociation = after;
          if (this.quotaAssociation.relation_type === "NM") {
            this.quotaAssociation.coefficient = "1.00000";
          }
        },
        deep: true
      }
    },
    methods: {
      parseData: function(payload) {
        return {
          workbasket_name: payload.workbasket_name,
          parent_quota: payload.parent_quota_order_id,
          child_quota: payload.child_quota_order_id,
          parent_definition_period: payload.parent_quota_definition_period,
          child_definition_period: payload.child_quota_definition_period,
          relation_type: payload.relation_type,
          coefficient: payload.coefficient,
        };
      },
      validateStepOneData: function (e) {
        WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));

        this.errors = {};

        if (!this.quotaAssociation.workbasket_name) {
          this.errors.workbasket_name = 'Workbasket name is required.';
        }

        if (!this.quotaAssociation.parent_quota) {
          this.errors.parent_quota = 'Parent (main) quota order number ID is required.';
        }

        if (!this.quotaAssociation.child_quota) {
          this.errors.child_quota = 'Child (sub) quota order number ID is required.';
        }

        // here make api request to validate quotas and redirect to step 2

        if (!this.hasErrors) {
          sessionStorage.quota_association = JSON.stringify(this.quotaAssociation);
          return true;
        }

        $(document).scrollTop($("#content").offset().top);
        WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();

        e.preventDefault();
      },
      validateStepTwoData: function (e) {
        e.preventDefault();

        WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));

        this.errors = {};

        if (!this.quotaAssociation.parent_definition_period || this.quotaAssociation.parent_definition_period === "") {
          this.errors.parent_definition_period = 'Parent quota definition period is required.';
        }

        if (!this.quotaAssociation.child_definition_period  || this.quotaAssociation.child_definition_period === "") {
          this.errors.child_definition_period = 'Child quota definition period is required.';
        }

        if (!this.quotaAssociation.relation_type) {
          this.errors.relation_type = 'Relation type is required.';
        }

        if (!this.quotaAssociation.coefficient || this.quotaAssociation.coefficient === "") {
          this.errors.coefficient = 'Co-efficientis required.';
        }

        // More validation can go here

        if (this.hasErrors) {
          $(document).scrollTop($("#content").offset().top);
          WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();
        } else {
          sessionStorage.quota_association = JSON.stringify(this.quotaAssociation);
          // make the api put request
          // capture server errors
        }
      }
    }
  });
});
