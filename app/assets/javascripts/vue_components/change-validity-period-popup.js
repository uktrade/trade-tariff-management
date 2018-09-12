Vue.component("change-validity-period-popup", {
  template: "#change-validity-period-popup-template",
  data: function() {
    return {
      startDate: null,
      endDate: null,
      makeOpenEnded: null,
      regulation: null,
      regulation_id: null,
      regulation_role: null,
      earliestStartDate: null,
      latestStartDate: null,
      earliestEndDate: null,
      latestEndDate: null,
      openEndedMeasures: 0,
      sameStartDate: null,
      sameEndDate: null,
      errors: [],
      errorSummary: [],
      disableSubmit: false
    };
  },
  props: ["measures", "onClose", "open"],
  mounted: function() {
    var self = this;

    var startDates = this.measures.map(function(measure) {
      return moment(measure.validity_start_date, "DD MMM YYYY", true);
    });

    var endDates = [];
    this.openEndedMeasures = 0;

    this.measures.forEach(function(measure) {
      if (measure.validity_end_date && measure.validity_end_date != "-") {
        endDates.push(moment(measure.validity_end_date + " 12:00:00", "DD MMM YYYY HH:mm:ss", true));
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
      var endDate = this.endDate;
      var makeOpenEnded = this.makeOpenEnded;
      var errors = {};
      var errorSummary = [];

      if (makeOpenEnded || !endDate) {
        return true;
      }

      this.measures.forEach(function(measure) {
        if (!measure.validity_end_date || measure.validity_end_date == "-") {
          if (!window.all_settings.regulation_id && !self.regulation_id) {
            isValid = false;
            errorSummary.push("You must specify a justification regulation when adding an end-date.");
            errors["regulation_id"] = "You must specify a justification regulation when adding an end-date.";
          }
        }
      });

      this.errors = errors;
      this.errorSummary = errorSummary;

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

      this.measures.forEach(function(measure) {
        if (startDate) {
          if (measure.validity_start_date != newStartDate) {
            if (measure.changes.indexOf("validity_start_date") === -1) {
              measure.changes.push("validity_start_date");
            }

            measure.validity_start_date = newStartDate;
          }
        }

        if (makeOpenEnded && measure.validity_end_date) {
          if (measure.changes.indexOf("validity_end_date") === -1) {
            measure.changes.push("validity_end_date");
          }

          measure.validity_end_date = null;
        } else if (endDate && newEndDate != measure.validity_end_date) {
          if (!measure.validity_end_date || measure.validity_end_date == "-") {
            if (this.regulation_id) {
              measure.changes.push("justification_regulation");
              measure.justification_regulation_id = this.regulation_id;
              measure.justification_regulation_role = this.regulation_role;
              measure.justification_regulation = this.regulation;
            } else if (window.all_settings.regulation_id) {
              measure.changes.push("justification_regulation");
              measure.justification_regulation_id = window.all_settings.regulation_id;
              measure.justification_regulation_role = window.all_settings.regulation_role;
              measure.justification_regulation = window.all_settings.regulation;

            }
          }

          measure.validity_end_date = newEndDate;

          if (measure.changes.indexOf("validity_end_date") === -1) {
            measure.changes.push("validity_end_date");
          }
        }

      });

      this.$emit("measures-updated");
      this.onClose();
    },
    triggerClose: function() {
      this.onClose();
    },
    regulationSelected: function(obj) {
      this.regulation_id = obj.regulation_id;
      this.regulation_role = obj.role;
      this.regulation = obj;
    }
  },
  computed: {
    showMakeOpenEnded: function() {
      return any(this.measures, function(measure) {
        return measure.validity_end_date && measure.validity_end_date != "-";
      });
    },
    showJustificationRegulation: function() {
      var endDate = this.endDate;
      if (!endDate || moment(endDate, "DD/MM/YYYY", true).isValid() == false) {
        return false;
      }

      return any(this.measures, function(measure) {
        return !measure.validity_end_date || measure.validity_end_date == "-";
      });
    }
  },
  watch: {
    makeOpenEnded: function(val) {
      if (val) {
        this.endDate = null;
      }
    },
    regulation_id: function(val) {
      if (val && this.errors['regulation_id']) {
        this.clearErrors();
      }
    }
  }
});
