function GeographicalAreasValidator(data) {
  this.data = data;
  this.errors = {};
  this.conformanceErrors = {};
  this.valid = true;
  this.level = "one";
  this.summary = "";
}

GeographicalAreasValidator.prototype.validate = function(action) {
  this.action = action;

  if (!this.validateLevelOne()) {
    this.valid = false;
    return this.gatherResults();
  }

  if (action === "submit_for_cross_check") {
    if (!this.validateLevelTwo()) {
      this.valid = false;
      return this.gatherResults();
    }

    if (!this.validateLevelThree()) {
      this.valid = false;
      return this.gatherResults();
    }
  }

  return this.gatherResults();
};

GeographicalAreasValidator.prototype.validateLevelOne = function() {
  var valid = true;
  var self = this;
  this.level = "one";

  if (this.data.workbasket_name.trim().length === 0) {
    this.errors.workbasket_name = "You must specify a workbasket name. The name must contain at least one word.";
    valid = false;
  }

  if (this.data.validity_start_date && moment(this.data.validity_start_date, "DD/MM/YYYY", true).isValid() == false) {
    this.errors.validity_start_date = "You must specify valid a date here.";
    valid = false;
  }

  var invalidCodes = any(this.data.additional_codes, function(code, index) {
    var hasError = code.additional_code.trim().length > 0 && !code.additional_code.match("^[0-9a-zA-Z]{3}$");

    if (hasError) {
      self.errors["additional_code_" + index] = "invalid";
    }

    return hasError;
  });

  if (invalidCodes) {
    this.errors.additional_codes = "One or more of the codes you have entered is invalid. Each code must be three characters long.";
    valid = false;
  }

  return valid;
};

GeographicalAreasValidator.prototype.validateLevelTwo = function() {
  this.level = "two";
  var valid = true;
  var self = this;

  var start_date = moment(this.data.validity_start_date, "DD/MM/YYYY", true);
  var end_date = moment(this.data.validity_end_date, "DD/MM/YYYY", true);

  if (!this.data.validity_start_date) {
    this.errors.validity_start_date = "You must specify a date here.";
    valid = false;
  } else if (!start_date.isValid()) {
    this.errors.validity_start_date = "You must specify valid a date here.";
    valid = false;
  }

  if (this.data.validity_end_date) {
    if (!end_date.isValid()) {
      this.errors.validity_end_date = "The end date, if specified, must be a valid date.";
      valid = false;
    } else if (end_date.diff(start_date, "days") <= 0) {
      this.errors.validity_end_date = "The end date, if specified, must be after the start date specified above.";
      valid = false;
    }
  }

  var invalidCodes = any(this.data.additional_codes, function(code, index) {
    var incompleteCode = code.additional_code.trim().length == 0;
    var incompleteDescription = code.description.trim().length == 0;
    var incompleteType = !code.additional_code_type_id;

    // if all blank, ignore
    if (incompleteCode && incompleteDescription && incompleteType) {
      return false;
    }

    if (incompleteCode) {
      self.errors["additional_code_" + index] = "invalid";
    }

    if (incompleteDescription) {
      self.errors["description_" + index] = "invalid";
    }

    if (incompleteType) {
      self.errors["additional_code_type_id_" + index] = "invalid";
    }

    return incompleteCode || incompleteDescription || incompleteType;
  });

  if (invalidCodes) {
    this.errors.additional_codes = "One or more of the specified codes is incomplete.";
    valid = false;
  }

  return valid;
};

GeographicalAreasValidator.prototype.validateLevelThree = function() {
  this.level = "three";
  var valid = true;

  return valid;
};

GeographicalAreasValidator.prototype.gatherResults = function() {
  this.setSummary();

  return {
    valid: this.valid,
    level: this.level,
    summary: this.summary,
    errors: this.errors,
    conformanceErrors: this.conformanceErrors
  };
};

GeographicalAreasValidator.prototype.setSummary = function() {
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

GeographicalAreasValidator.prototype.parseBackendErrors = function(action, errors) {
  var self = this;
  this.valid = true;
  this.action = action;

  if (errors.general) {
    if (errors.general.workbasket_name) {
      self.setLevel("one");
      this.errors.workbasket_name = errors.general.workbasket_name;
      this.valid = false;
    }

    if (errors.general.validity_start_date) {
      self.setLevel("one");
      this.errors.validity_start_date = errors.general.validity_start_date;
      this.valid = false;
    }

    if (!this.valid) {
      return this.gatherResults();
    }

    delete errors.general;
  }

  var invalidCodes = false;

  for (var k in errors) {
    if (!errors.hasOwnProperty(k)) {
      continue;
    }

    var message = errors[k];

    if (k.indexOf("additional_code_description_") > -1) {
      k = k.replace("additional_code_description_", "description_");
      self.setLevel("three");
      invalidCodes = true;
    } else if (k.indexOf("additional_code_additional_code_") > -1) {
      k = k.replace("additional_code_additional_code_", "additional_code_");
      self.setLevel("two");
      invalidCodes = true;
    } else if (isObject(message)) {
      self.setLevel("four");
      this.valid = false;

      for (var kk in message) {
        if (message.hasOwnProperty(kk)) {
          var conformanceError = self.parseConformanceMessage(message[kk]);
          this.conformanceErrors[conformanceError.code] = conformanceError.message;
        }
      }

      continue;
    } else {
      self.setLevel("two");
    }

    this.errors[k] = message;
    this.valid = false;
  }

  if (invalidCodes) {
    this.errors.additional_codes = "One or more of the specified codes is incomplete.";
  }

  return this.gatherResults();
};

GeographicalAreasValidator.prototype.setLevel = function(level) {
  var ordered = ["one", "two", "three", "four"];

  var currentIndex = ordered.indexOf(this.level);
  var argumentIndex = ordered.indexOf(level);

  if (currentIndex === -1 || currentIndex < argumentIndex) {
    this.level = level;
  }
};

GeographicalAreasValidator.prototype.parseConformanceMessage = function(message) {
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
