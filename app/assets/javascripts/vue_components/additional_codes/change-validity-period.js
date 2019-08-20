Vue.component("change-additional-codes-validity-period-popup", {
  template: "#change-additional-codes-validity-period-popup-template",
  data: function() {
    return {
      startDate: null,
      endDate: null,
      makeOpenEnded: null,
      earliestStartDate: null,
      latestStartDate: null,
      earliestEndDate: null,
      latestEndDate: null,
      openEndedRecords: 0,
      sameStartDate: null,
      sameEndDate: null,
      errors: [],
      errorSummary: [],
      disableSubmit: false
    };
  },
  props: ["records", "onClose", "open"],
  mounted: function() {
    var self = this;

    var startDates = this.records.map(function(record) {
      return moment(record.validity_start_date, "DD MMM YYYY", true);
    });

    var endDates = [];
    this.openEndedMeasures = 0;

    this.records.forEach(function(record) {
      if (record.validity_end_date && record.validity_end_date != "-") {
        endDates.push(moment(record.validity_end_date + " 12:00:00", "DD MMM YYYY HH:mm:ss", true));
      } else {
        self.openEndedMeasures += 1;
      }
    });

    startDates.sort(function(a,b) {
      return a.diff(b, "days");
    });

    endDates.sort(function(a,b) {
      return a.diff(b, "days");
    });

    this.earliestStartDate = startDates[0].format("DD MMM YYYY");
    this.latestStartDate = startDates[startDates.length - 1].format("DD MMM YYYY");

    this.sameStartDate = startDates[0].isSame(startDates[startDates.length - 1], "day");

    if (endDates.length > 0) {
      this.earliestEndDate = endDates[0].format("DD MMM YYYY");
      this.latestEndDate = endDates[endDates.length - 1].format("DD MMM YYYY");
      this.sameEndDate = endDates[0].isSame(endDates[endDates.length - 1], "day") && this.openEndedMeasures == 0;
    } else {
      this.sameEndDate = true;
    }

    // date picker requires this format
    this.startDate = startDates[0].format("DD/MM/YYYY");
    // we probably should display the latest end date
    this.endDate = endDates[0].format("DD/MM/YYYY");
  },
  methods: {
    clearErrors: function() {
      this.errors = {};
      this.errorSummary = [];
    },
    validate: function() {
      this.clearErrors();

      var self = this;
      var isValid = true;
      var todaysDate = moment().startOf('day');
      var startDate = moment(this.startDate, "DD/MM/YYYY", true);
      var endDate = moment(this.endDate, "DD/MM/YYYY", true);
      var makeOpenEnded = this.makeOpenEnded;
      var errors = {};
      this.errorSummary = "";

      if (startDate.isValid() === false) {
        isValid = false;
        errors.startDate = "You must specify a start date.";
      } else if (startDate.diff(todaysDate, "days") <= 0) {
        isValid = false;
        errors.startDate = "Start date must be in the future.";
      }

      if (!makeOpenEnded) {
        if (endDate.isValid() === false) {
          isValid = false;
          errors.endDate = "You must specify an end date.";
        } else if (endDate.diff(startDate, "days") <= 0) {
          isValid = false;
          errors.endDate = "End date must be after the start date.";
        }
      }

      if (!isValid) {
        this.errorSummary = "The change could not be made because some fields are missing or contain invalid data.";
      }

      this.errors = errors;

      return isValid;
    },
    confirmChanges: function() {
      var startDate = this.startDate;
      var endDate = this.endDate;
      var makeOpenEnded = this.makeOpenEnded;
      var newStartDate = moment(startDate, "DD/MM/YYYY", true).format("DD MMM YYYY");
      var newEndDate = moment(endDate, "DD/MM/YYYY", true).format("DD MMM YYYY");

      this.disableSubmit = true;

      if (!this.validate()) {
        $(this.$el).find(".modal__container").scrollTop(0);
        this.disableSubmit = false;

        return;
      }

      this.records.forEach(function(record) {
        if (startDate) {
          if (record.validity_start_date != newStartDate) {
            if (record.changes.indexOf("validity_start_date") === -1) {
              record.changes.push("validity_start_date");
            }

            record.validity_start_date = newStartDate;
          }
        }

        if (makeOpenEnded && record.validity_end_date) {
          if (record.changes.indexOf("validity_end_date") === -1) {
            record.changes.push("validity_end_date");
          }

          record.validity_end_date = null;
        } else if (endDate && newEndDate != record.validity_end_date) {
          record.validity_end_date = newEndDate;

          if (record.changes.indexOf("validity_end_date") === -1) {
            record.changes.push("validity_end_date");
          }
        }

      });

      this.$emit("records-updated");
      this.onClose();
    },
    triggerClose: function() {
      this.onClose();
    }
  },
  computed: {
    showMakeOpenEnded: function() {
      return any(this.records, function(record) {
        return record.validity_end_date && record.validity_end_date != "-";
      });
    }
  },
  watch: {
    makeOpenEnded: function(val) {
      if (val) {
        this.endDate = null;
      }
    }
  }
});
