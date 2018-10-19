$(document).ready(function() {

  var form = document.querySelector(".clone-quota");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      return {
        workbasket_name: "",
        errors: {},
        errorsSummary: "",
        hasErrors: false,
        selectAll: false,
        excludeOrderNumber: false,
        excludeCommodityCodes: false,
        excludeAdditionalCodes: false,
        excludeRegulation: false,
        excludeOrigin: false,
        excludeConditions: false,
        excludeFootnotes: false,

        updatingSelectAll: false
      };
    },
    computed: {
      allSame: function() {
        var all = !this.excludeCommodityCodes &&
                  !this.excludeAdditionalCodes &&
                  !this.excludeOrderNumber &&
                  !this.excludeOrigin;

        return all;
      }
    },
    methods: {
      updateSelectAll: function() {
        var self = this;

        var all = this.excludeCommodityCodes &&
                  this.excludeAdditionalCodes &&
                  this.excludeOrderNumber &&
                  this.excludeRegulation &&
                  this.excludeOrigin &&
                  this.excludeConditions &&
                  this.excludeFootnotes;

        this.updatingSelectAll = true;
        this.selectAll = all;

        Vue.nextTick(function() {
          self.updatingSelectAll = false;
        });
      },
      validate: function(e) {
        this.errors = {};
        this.hasErrors = false;
        this.errorsSummary = "";

        if (this.workbasket_name.trim().length === 0) {
          this.errors.workbasket_name = "You must specify a workbasket name. The name must contain at least one word.";
          this.hasErrors = true;
          this.errorsSummary = "You cannot proceed yet because you have not entered the minimum required data.";
        }

        if (this.hasErrors) {
          e.preventDefault();
          return;
        }

        if (this.allSame) {
          this.errors.exclusions = "You must select at least one attribute from the list below.";
          this.hasErrors = true;
          this.errorsSummary = "The selected measures could not be cloned because you did not exclude any attributes.";
        }

        if (this.hasErrors) {
          e.preventDefault();
          return;
        }
      }
    },
    watch: {
      selectAll: function(val) {
        if (this.updatingSelectAll) {
          return;
        }

        this.excludeCommodityCodes = val;
        this.excludeAdditionalCodes = val;
        this.excludeOrigin = val;
        this.excludeOrderNumber = val;
        this.excludeRegulation = val;
        this.excludeConditions = val;
        this.excludeFootnotes = val;
      },
      excludeCommodityCode: function(val) {
        this.updateSelectAll();
      },
      excludeOrigin: function(val) {
        this.updateSelectAll();
      },
      excludeDuties: function(val) {
        this.updateSelectAll();
      },
      excludeConditions: function(val) {
        this.updateSelectAll();
      },
      excludeFootnotes: function(val) {
        this.updateSelectAll();
      }
    }
  });
});
