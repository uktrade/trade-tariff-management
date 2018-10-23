Vue.component("edit-geographical-area-membership-popup", {
  template: "#edit-geographical-area-membership-popup-template",
  props: ["membership", "geographicalArea", "onClose", "open"],
  data: function() {
    return {
      delete: false,
      valid: true,
      errors: {},
      join_date: null,
      leave_date: null,
      processing: false
    };
  },
  computed: {
    disableJoinDate: function() {
      console.log(this.geographicalArea);
    }
  },
  methods: {
    validate: function(resolve, reject) {
      var self = this;

      this.errors = {};
      this.errorSummary = "";
      this.valid = true;

      if (this.delete) {
        return resolve();
      }

      if (!this.valid) {
        return reject();
      }

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
        for (var k in areas) {
          if (!areas.hasOwnProperty(k)) {
            continue;
          }

          var area = areas[k];

          self.geographicalArea.geographical_area_memberships.push({
            geographical_area: area,
            geographical_area_id: area.geographical_area_id,
            geographical_area_group_sid: self.geographicalArea.geographical_area_id,
            validity_start_date: self.join_date,
            validity_end_date: self.leave_date
          });
        }

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
