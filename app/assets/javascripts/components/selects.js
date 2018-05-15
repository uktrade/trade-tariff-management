$(document).ready(function() {
  $(".selectize").each(function() {
    var config = {
      create: false,
      allowClear: true
    };

    var options = $(this).data("options");

    if (options) {
      config.options = options;

      var value = $(this).data("value");
      var label = $(this).data("label");
      var code = $(this).data("code");
      var codeClassName = $(this).data("code-class");

      if (value) {
        config.valueField = value;
      }

      if (label) {
        config.labelField = label;
      }

      if (code) {
        config["render"] = {
          option: function(data) {
            return "<span class='selection'><span class='option-prefix " + codeClassName + "'>" + data[code] + "</span>" + data[label] + "</span></span>";
          },
          item: function(data) {

            return "<div class='item'>" + data[code] + " - " + data[label] + "</div>";
          }
        };
      }
    }

    $(this).selectize(config)
  });
});
