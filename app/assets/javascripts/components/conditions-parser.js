window.ConditionsParser = {
  parse: function(options) {
    var newOptions = [];
    var mappings = {
      "E": [
        {
          condition_code: "E1",
          description: "The quantity declared is equal or less than the specified maximum"
        },
        {
          condition_code: "E2",
          description: "The price per unit declared is equal or less than the specified maximum"
        },
        {
          condition_code: "E3",
          description: "Presentation of the required document"
        }
      ],
      "I": [
        {
          condition_code: "I1",
          description: "The quantity  declared is equal or less than the specified maximum"
        },
        {
          condition_code: "I2",
          description: "The price per unit declared is equal or less than the specified maximum"
        },
        {
          condition_code: "I3",
          description: "Presentation of the required document"
        }
      ],
      "M": [
        {
          condition_code: "M1",
          description: "Declared price must be equal to or greater than the minimum price (see components)"
        },
        {
          condition_code: "M2",
          description: "Declared price must be equal to or greater than the reference price (see components)"
        }
      ]
    };

    options.forEach(function (option) {
      var newOption = null;

      if (mappings[option.condition_code] !== undefined) {
        mappings[option.condition_code].forEach(function(newOption) {
          newOptions.push(newOption);
        });
      } else {
        newOptions.push(option);
      }
    });

    return newOptions;
  },
  getConditionCode: function(condition) {
    if (condition.condition_code == "E") {
      if (condition.certificate_type_code) {
        return "E3";
      } else if (condition.monetary_unit_code) {
        return "E2";
      } else {
        return "E1";
      }
    } else if (condition.condition_code == "I") {
      if (condition.certificate_type_code) {
        return "I3";
      } else if (condition.monetary_unit_code) {
        return "I2";
      } else {
        return "I1";
      }
    } else if (condition.condition_code == "M") {
      return "M1";
      // there's no seemingly possible way to determine if it's M2
    } else {
      return condition.condition_code;
    }
  }
};
