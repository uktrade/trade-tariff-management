Vue.component("add-geo-areas-to-country-region-popup", {
  template: "#add-geo-areas-to-country-region-popup-template",
  props: {
    "geographicalArea": Object,
    "validityStartDate": String,
    "onClose": Function,
    "open": Boolean
  },
  data: function() {
    return {
      memberships: [],
      valid: true,
      errors: [],
      processing: false,
      groupsList: window.__geographical_area_groups_json
    };
  },
  mounted: function() {
    this.addMembership();
  },
  methods: {
    addMembership: function() {
      var start_date = moment(this.geographicalArea.validity_start_date, "DD/MM/YYYY", true);

      this.memberships.push({
        geographical_area: null,
        geographical_area_id: null,
        validity_start_date: start_date.isValid() ? this.geographicalArea.validity_start_date : null,
        validity_end_date: null,
        geographical_area_group_sid: null
      });
    },
    membershipAreaSelected: function(membershipIndex, selectedArea) {
      var membership = this.memberships[membershipIndex];
      membership.geographical_area = selectedArea;
      membership.geographical_area_id = selectedArea.geographical_area_id;
    },
    validate: function() {
      var self = this;

      self.errors = [];
      self.errorSummary = "";
      self.valid = true;

      this.memberships.forEach(function(membership) {
        if (membership.validity_start_date === null) {
          self.valid = false;
          self.errorSummary = "Memberships could not be added because one or more joining dates are missing.";
        }

        if (membership.geographical_area === null) {
          self.valid = false;
          self.errorSummary = "Memberships could not be added because one or more area groups are missing.";
        }
      });

      return self.valid;
    },
    addMemberships: function() {
      var self = this;

      this.processing = true;

      if (!this.validate()) {
        this.processing = false;
        return;
      }

      var currentMembershipIds = self.geographicalArea.geographical_area_memberships.map(function(currentMembership) {
        return currentMembership.geographical_area_id;
      });

      this.memberships.forEach(function(membership) {
        if(!currentMembershipIds.includes(membership.geographical_area_id)) {
          self.geographicalArea.geographical_area_memberships.push(membership);
        }
      });

      this.onClose();
    },
    triggerClose: function() {
      this.onClose();
    }
  }
});
