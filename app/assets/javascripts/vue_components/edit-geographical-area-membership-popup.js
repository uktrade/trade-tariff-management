Vue.component("edit-geographical-area-membership-popup", {
  template: "#edit-geographical-area-membership-popup-template",
  props: ["membership", "geographicalArea", "onClose", "open"],
  data: function() {
    return {
      valid: true,
      errors: {},
      errorSummary: "",
      join_date: null,
      leave_date: null,
      processing: false
    };
  },
  mounted: function() {
  },
  computed: {
    disableJoinDate: function() {
      return this.geographicalArea.sent_to_cds;
    },
    isGroup: function() {
      return this.geographicalArea.geographical_code === 'group';
    }
  },
  methods: {
    validate: function(resolve, reject) {
      var self = this;

      this.errors = {};
      this.errorSummary = "";
      this.valid = true;

      if (moment(this.join_date, "DD/MM/YYYY", true).isValid() === false) {
        this.errors.join_date = "The join date must be valid";
        this.valid = false;
        this.errorSummary = "Membership could not be updated because invalid data has been entered for one or more fields.";
      }

      if (this.leave_date && moment(this.leave_date, "DD/MM/YYYY", true).isValid() === false) {
        this.errors.leave_date = "The leave date, if entered, must be valid";
        this.valid = false;
        this.errorSummary = "Membership could not be updated because invalid data has been entered for one or more fields.";
      }

      if (!this.valid) {
        return reject();
      }

      return resolve();
    },
    updateMembership: function() {
      var self = this;

      this.processing = true;

      this.validate(function() {
        var membership = self.membership;

        self.onClose();
      }, function() {
        self.processing = false;
      });
    },
    triggerClose: function() {
      this.onClose();
    }
  }
});
