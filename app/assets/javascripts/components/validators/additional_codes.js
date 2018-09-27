function AdditionalCodesValidator(data) {
  this.data = data;
  this.errors = {};
  this.valid = false;
  this.level = "one";
  this.summary = "";
}

AdditionalCodesValidator.prototype.validate = function(action) {
  this.action = action;

  if (!this.validateLevelOne()) {
    return this.gatherResults();
  }

  if (action === "submit_for_cross_check") {
    if (!this.validateLevelTwo()) {
      return this.gatherResults();
    }

    if (!this.validateLevelThree()) {
      return this.gatherResults();
    }
  }

  return this.gatherResults();
};

AdditionalCodesValidator.prototype.validateLevelOne = function() {
  var valid = true;
  var self = this;
  this.level = "one";

  if (this.data.workbasket_name.trim().length === 0) {
    this.errors.workbasket_name = "You must specify a workbasket name. The name must contain at least one word."
    valid = false;
  }

  var invalidCodes = any(this.data.additional_codes, function(code, index) {
    var hasError = !code.additional_code.trim().length > 0 && !code.additional_code.match("^[0-9a-zA-Z]{3}$");

    if (hasError) {
      self.errors["additional_code_" + index] = "invalid";
    }

    return hasError;
  });

  if (invalidCodes) {
    this.errors.additional_codes = "One or more of the codes you have entered is invalid. Each code must be three characters long.";
    valid = false;
  }

  if (!valid) {
    this.setSummary();
  }

  return valid;
};

AdditionalCodesValidator.prototype.validateLevelTwo = function() {
  this.level = "two";

};

AdditionalCodesValidator.prototype.validateLevelThree = function() {
  this.level = "three";

};

AdditionalCodesValidator.prototype.gatherResults = function() {
  return {
    valid: this.valid,
    level: this.level,
    summary: this.summary,
    errors: this.errors
  };
};

AdditionalCodesValidator.prototype.setSummary = function() {
  if (this.level == "one" && this.action == "save_progress") {
    this.summary = "You cannot save progress yet because you have not entered the minimum required data.";
  } else if (this.level == "one") {
    this.summary = "You cannot submit for cross-check yet because you have not entered the minimum required data.";
  } else if (this.level == "two" && this.action == "save_progress") {
    this.summary = "You cannot save progress yet because there is invalid data that cannot be saved.";
  }  else if (this.level == "two") {
    this.summary = "You cannot submit for cross-check yet because there is invalid data that cannot be saved..";
  } else if (this.level == "three") {
    this.summary = "There is missing and/or invalid data on this page.";
  } else if (this.level == "four") {
    this.summary = "There are conformance errors that mean the additional codes are not ready to be submitted yet.";
  }
};
