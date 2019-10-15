$(document).ready(function() {
  var form = document.querySelector("#vue-create-quota-suspension-form");

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
        quota_order_number_id: null
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

      if (sessionStorage.quota_suspension) {
        this.quotaSuspension = JSON.parse(sessionStorage.quota_suspension);
      }
    },
    watch: {
    },
    methods: {
      parseData: function(payload) {
        return {
          workbasket_name: payload.workbasket_name
        };
      },
      validateStepOneData: function (e) {
        WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));

        this.errors = {};

        if (!this.quotaSuspension.workbasket_name) {
          this.errors.workbasket_name = 'Workbasket name is required.';
        }

        if (!this.quotaSuspension.quota_order_number_id) {
          this.errors.child_quota = 'Quota order number ID is required.';
        }

        if (!this.hasErrors) {
          sessionStorage.quota_suspension = JSON.stringify(this.quotaSuspension);
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

        if (!this.quotaSuspension.quota_order_number_id) {
          this.errors.quota_order_number_id = 'Quota order number ID is required';
        }

        if (this.hasErrors) {
          $(document).scrollTop($("#content").offset().top);
          WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner();
        } else {
          sessionStorage.quota_suspension = JSON.stringify(this.quotaSuspension);
        }
      }
    }
  });
});
