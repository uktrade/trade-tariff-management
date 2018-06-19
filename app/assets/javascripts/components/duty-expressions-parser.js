window.DutyExpressionsParser = {
  parse: function(options) {
    var newOptions = [];

    options.forEach(function (option) {
      option.duty_expression_code = option.duty_expression_id;
      var newOption = null;

      if (option.duty_expression_id === "01") {
        option.duty_expression_id = "01A";
        option.description = "% (ad valorem)";
        option.abbreviation = "+ %";

        newOption = {
          duty_expression_code: option.duty_expression_code,
          duty_expression_id: "01B",
          description: "Specific duty rate",
          abbreviation: "+ €"
        };
      } else if (option.duty_expression_id === "02") {
        option.duty_expression_id = "02A";
        option.description = "Minus %";
        option.abbreviation = "- %";

        newOption = {
          duty_expression_code: option.duty_expression_code,
          duty_expression_id: "02B",
          description: "Minus amount",
          abbreviation: "- €"
        };
      } else if (option.duty_expression_id === "04") {
        option.duty_expression_id = "04A";
        option.description = "Plus %";
        option.abbreviation = "+ %";

        newOption = {
          duty_expression_code: option.duty_expression_code,
          duty_expression_id: "04B",
          description: "Plus amount",
          abbreviation: "+ €"
        };
      } else if (option.duty_expression_id === "19") {
        option.duty_expression_id = "19A";
        option.description = "Plus %";
        option.abbreviation = "+ %";

        newOption = {
          duty_expression_code: option.duty_expression_code,
          duty_expression_id: "19B",
          description: "Plus amount",
          abbreviation: "+ €"
        };
      } else if (option.duty_expression_id === "20") {
        option.duty_expression_id = "20A";
        option.description = "Plus %";
        option.abbreviation = "+ %";

        newOption = {
          duty_expression_code: option.duty_expression_code,
          duty_expression_id: "20B",
          description: "Plus amount",
          abbreviation: "+ €"
        };
      }

      newOptions.push(option);

      if (newOption) {
        newOptions.push(newOption);
      }
    });

    return newOptions;
  }
};
