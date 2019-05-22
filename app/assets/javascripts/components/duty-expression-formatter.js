window.DutyExpressionFormatter = {
  prettify: function(num) {
    var n = numeral(num);

    return n.format("0,0.00[00]");
  },
  format: function(opts) {
    var duty_expression_id = opts.duty_expression_id;
    var duty_expression_description = opts.duty_expression_description;
    var duty_expression_abbreviation = opts.duty_expression_abbreviation;
    var duty_amount = opts.duty_amount;
    var monetary_unit = opts.monetary_unit_abbreviation || opts.monetary_unit;
    var measurement_unit = opts.measurement_unit;
    var measurement_unit_qualifier = opts.measurement_unit_qualifier;
    var measurement_unit_abbreviation = measurement_unit ? measurement_unit.abbreviation : null;

    if (monetary_unit && monetary_unit.monetary_unit_code) {
      monetary_unit = monetary_unit.monetary_unit_code;
    }

    var output = [];
    switch(duty_expression_id) {
      case "99":
        if (opts.formatted) {
          output.push("<abbr title='" + measurement_unit.description + "'>" + measurement_unit_abbreviation + "</abbr>");
        } else {
          output.push(measurement_unit_abbreviation)
        }
        break;
      case "12":
      case "14":
      case "37":
      case "40":
      case "41":
      case "42":
      case "43":
      case "44":
      case "21":
      case "25":
      case "27":
      case "29":
        if (duty_expression_abbreviation) {
          output.push(duty_expression_abbreviation);
        } else if (duty_expression_description) {
          output.push(duty_expression_description);
        }
        break;
      case "02":
      case "04":
      case "15":
      case "17":
      case "19":
      case "20":
      case "36":
        if (duty_expression_abbreviation) {
          output.push(duty_expression_abbreviation.replace("%", "").replace("€", "").replace("≤", "MAX"));
        } else if (duty_expression_description) {
          output.push(duty_expression_description);
        }

        if (duty_amount) {
          output.push(this.prettify(duty_amount));
        }

        if (monetary_unit) {
          output.push(monetary_unit);
        } else {
          output.push("%");
        }

        if (measurement_unit_abbreviation) {
          if (opts.formatted) {
            output.push("/ <abbr title='" + measurement_unit.description + "'>" + measurement_unit_abbreviation + "</abbr>");
          } else {
            output.push("/ " + measurement_unit_abbreviation);
          }
        }

        break;
      default:
        if (duty_amount) {
          output.push(this.prettify(duty_amount));
        }

        if (duty_expression_abbreviation && !monetary_unit) {
          output.push(duty_expression_abbreviation);
        } else if (duty_expression_description && !monetary_unit) {
          output.push(duty_expression_description);
        } else if (duty_expression_description === null) {
          output.push("%");
        }

        if (monetary_unit) {
          output.push(monetary_unit.monetary_unit_code);
        }

        if (measurement_unit_abbreviation) {
          if (opts.formatted) {
            output.push("/ <abbr title='" + measurement_unit.description + "'>" + measurement_unit_abbreviation + "</abbr>");
          } else {
            output.push("/ " + measurement_unit_abbreviation);
          }
        }
    }

    return output.join(" ");
  }
};
