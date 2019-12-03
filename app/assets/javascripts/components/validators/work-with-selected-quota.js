function WorkWithSelectedQuotaValidator(data) {
  this.data = data;
  this.errors = {};
  this.conformanceErrors = {};
  this.valid = true;
  this.level = "one";
  this.summary = "";
}

WorkWithSelectedQuotaValidator.prototype.validate = function(action) {
  this.action = action;

  if (!this.validateLevelOne()) {
    this.valid = false;
    return this.gatherResults();
  }

  if (!this.validateLevelTwo()) {
    this.valid = false;
    return this.gatherResults();
  }

  if (!this.validateLevelThree()) {
    this.valid = false;
    return this.gatherResults();
  }

  return this.gatherResults();
};

WorkWithSelectedQuotaValidator.prototype.validateLevelOne = function() {
  var valid = true;
  var self = this;
  this.level = "one";

  if (this.data.workbasket_name.trim().length === 0) {
    this.errors.workbasket_name = "You must specify a workbasket name. The name must contain at least one word.";
    valid = false;
  }

  return valid;
};

WorkWithSelectedQuotaValidator.prototype.validateLevelTwo = function() {
  this.level = "two";
  var valid = true;
  var self = this;

  if (this.data.validity_start_date && moment(this.data.validity_start_date, "DD/MM/YYYY", true).isValid() == false) {
    this.errors.validity_start_date = "You must specify valid a date here.";
    valid = false;
  }

  return valid;
};

WorkWithSelectedQuotaValidator.prototype.validateLevelThree = function() {
  this.level = "three";
  var valid = true;

  var start_date = moment(this.data.validity_start_date, "DD/MM/YYYY", true);
  var suspension_date = moment(this.data.suspension_date, "DD/MM/YYYY", true);

  if (!this.data.validity_start_date) {
    this.errors.validity_start_date = "You must specify a date here.";
    valid = false;
  } else if (!start_date.isValid()) {
    this.errors.validity_start_date = "You must specify valid a date here.";
    valid = false;
  }

  if (this.data.action == "suspend_quota" && this.data.suspension_date && !suspension_date.isValid()) {
    this.errors.suspension_date = "The suspension end date, if specified, must be valid.";
    this.errors.action = " ";
    valid = false;
  }

  if (this.data.reason.trim().length === 0) {
    this.errors.reason = "You must specify a reason for the changes.";
    valid = false;
  }

  if (!this.data.regulation_id && !this.data.changesNotFromLegislation) {
    this.errors.regulation = "Unless the changes do not come from legislation, you must specify the regulation here.";
    valid = false;
  }

  return valid;
};

WorkWithSelectedQuotaValidator.prototype.gatherResults = function() {
  this.setSummary();

  return {
    valid: this.valid,
    level: this.level,
    summary: this.summary,
    errors: this.errors,
    conformanceErrors: this.conformanceErrors
  };
};

WorkWithSelectedQuotaValidator.prototype.setSummary = function() {
  if (this.level == "one" && this.action == "continue") {
    this.summary = "You cannot proceed yet because you have not entered the minimum required data.";
  } else if (this.level == "one") {
    this.summary = "You cannot submit for approval yet because you have not entered the minimum required data.";
  } else if (this.level == "two" && this.action == "continue") {
    this.summary = "You cannot proceed yet because there is invalid data that cannot be saved.";
  }  else if (this.level == "two") {
    this.summary = "You cannot submit for approval yet because there is invalid data that cannot be saved..";
  } else if (this.level == "three") {
    this.summary = "There is missing and/or invalid data on this page.";
  }
};

WorkWithSelectedQuotaValidator.prototype.setLevel = function(level) {
  var ordered = ["one", "two", "three", "four"];

  var currentIndex = ordered.indexOf(this.level);
  var argumentIndex = ordered.indexOf(level);

  if (currentIndex === -1 || currentIndex < argumentIndex) {
    this.level = level;
  }
};

WorkWithSelectedQuotaValidator.prototype.parseConformanceMessage = function(message) {
  var regex = new RegExp(/(^[\w]+)\:\s([\w\s]*)/gm);
  var matches = regex.exec(message);

  if (!matches) {
    return {};
  }

  return {
    code: matches[1],
    message: matches[2]
  };
};
