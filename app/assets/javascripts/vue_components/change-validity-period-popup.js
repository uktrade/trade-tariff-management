Vue.component("change-validity-period-popup", {
  template: "#change-validity-period-popup-template",
  data: function() {
    return {
      startDate: null,
      endDate: null,
      makeOpenEnded: null,
      earliestStartDate: null,
      latestStartDate: null,
      earliestEndDate: null,
      latestEndDate: null,
      openEndedMeasures: null,
      sameStartDate: null,
      sameEndDate: null
    };
  },
  props: ["measures", "onClose", "open"],
  mounted: function() {
    var startDates = this.measures.map(function(measure) {
      return moment(measure.validity_start_date, "DD MMM YYYY", true);
    });

    var endDates = [];
    this.openEndedMeasures = 0;

    this.measures.forEach(function(measure) {
      if (measure.validity_end_date) {
        endDates.push(moment(measure.validity_end_date, "DD MMM YYYY", true));
      } else {
        this.openEndedMeasures += 1;
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
      this.sameEndDate = endDates[0].isSame(endDates[endDates.length - 1], "day");
    }
  },
  methods: {
    confirmChanges: function() {
      var startDate = this.startDate;
      var endDate = this.endDate;
      var makeOpenEnded = this.makeOpenEnded;
      var newStartDate = moment(startDate, "DD/MM/YYYY", true).format("DD MMM YYYY");
      var newEndDate = moment(endDate, "DD/MM/YYYY", true).format("DD MMM YYYY");

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
          measure.validity_end_date = newEndDate;

          if (measure.changes.indexOf("validity_end_date") === -1) {
            measure.changes.push("validity_end_date");
          }
        }
      });

      this.onClose();
    },
    triggerClose: function() {
      this.onClose();
    },
  }
});
