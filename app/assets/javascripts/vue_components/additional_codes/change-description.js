Vue.component("change-additional-codes-description-popup", {
  template: "#change-additional-codes-description-popup-template",
  data: function() {
    return {
      validityDate: moment().add(1, "days").format("DD/MM/YYYY"),
      description: "",
      sameDescription: false,
      meursing: 0,
      latestStartDate: null,
      errors: [],
      errorSummary: [],
      disableSubmit: false,
      additional_codes: []
    };
  },
  props: ["records", "onClose", "open"],
  mounted: function() {
    var self = this;

    this.additional_codes = this.records.filter(function(record) {
      return record.type_id != "7";
    });

    this.meursing = this.records.length - this.additional_codes.length;

    this.sameDescription = allValuesSame(this.additional_codes.map(function(record) {
      return record.description;
    }));

    if (this.sameDescription) {
      this.description = this.additional_codes[0] ? this.additional_codes[0].description : "";
    }


    try {
      this.latestStartDate = this.additional_codes.map(function(record) {
        return moment(record.additional_code_description.validity_start_date, "DD MMM YYYY", true);
      }).filter(function(date) {
        return date.isValid();
      }).sort(function(a,b) {
        return b.diff(a, "days");
      })[0].format("DD MMM YYYY");
    } catch (e) {
      this.latestStartDate = "";
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
      var validityDate = moment(this.validityDate, "DD/MM/YYYY", true);
      var latestStartDate = moment(this.latestStartDate, "DD MMM YYYY", true);
      var description = this.description;
      var errors = {};
      this.errorSummary = "";

      if (!validityDate.isValid()) {
        isValid = false;
        errors.validityDate = "You must specify a valid date.";
      }

      if (description.trim().length === 0) {
        isValid = false;
        errors.description = "You must specify a description.";
      }

      if (!isValid) {
        this.errorSummary = "The change could not be made because some fields are missing or contain invalid data.";
      }

      this.errors = errors;

      return isValid;
    },
    confirmChanges: function() {
      var validityDate = moment(this.validityDate, "DD/MM/YYYY", true).format("DD MMM YYYY");
      var description = this.description;

      this.disableSubmit = true;

      if (!this.validate()) {
        $(this.$el).find(".modal__container").scrollTop(0);
        this.disableSubmit = false;

        return;
      }

      this.additional_codes.forEach(function(record) {
        record.description = description;
        record.additional_code_description.description = description;
        record.additional_code_description.validity_start_date = validityDate;
        record.changes.push("description");
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
      return any(this.additional_codes, function(record) {
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
