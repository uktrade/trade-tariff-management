Vue.component('custom-select', {
  props: [
    "url",
    "value",
    "options",
    "placeholder",
    "labelField",
    "valueField",
    "searchField",
    "codeField",
    "minLength",
    "dateSensitive",
    "drilldownName",
    "drilldownValue",
    "drilldownRequired",
    "onChange",
    "allowClear",
    "name",
    "codeClassName",
    "abbreviationClassName"
  ],
  data: function() {
    return {
      condition: {},
      start_date: window.measure_start_date,
      end_date: window.measure_end_date,
    }
  },
  template: "#selectize-template",
  mounted: function () {
    var vm = this;

    var options = {
      create: false,
      items: [this.value],
      placeholder: this.placeholder,
      valueField: this.valueField,
      labelField: this.labelField,
      allowClear: this.allowClear || false,
      searchField: [this.valueField, this.codeField, "abbreviation", this.labelField]
    };

    if (this.onChange) {
      options.onChange = function(value) {
        var item = this.options[value];

        vm.onChange(item);
      }
    }

    if (this.codeField) {
      options.sortField = this.codeField;
    }

    if (this.options) {
      options["options"] = this.options;
    }

    if (this.url && !this.minLength) {
      options["onInitialize"] = function() {
        var self = this;
        var fn = self.settings.load;
        self.load(function(callback) {
          fn.apply(self, ["", callback]);
        });
      };

      options.onLoad = function(data) {
        if (vm.url && !vm.minLength && vm.value && !vm.firstLoadSelected) {
          $(vm.$el).find("select")[0].selectize.setValue(vm.value.toString());
          vm.firstLoadSelected = true;
        }
      };
    }

    if (this.url) {
      options["load"] = function(query, callback) {
        $(vm.$el).find("select")[0].selectize.clearOptions();
        $(vm.$el).find("select")[0].selectize.clearCache();
        $(vm.$el).find("select")[0].selectize.refreshOptions();
        $(vm.$el).find("select")[0].selectize.renderCache['option'] = {};
        $(vm.$el).find("select")[0].selectize.renderCache['item'] = {};

        if (vm.minLength && query.length < vm.minLength) return callback();
        if (vm.drilldownRequired === "true" && !vm.drilldownValue) return callback();

        var data = {
          q: query,
          start_date: vm.start_date,
          end_date: vm.end_date
        };

        if (vm.drilldownName && vm.drilldownValue) {
          data[vm.drilldownName] = vm.drilldownValue;
        }

        $.ajax({
          url: vm.url,
          data: data,
          type: 'GET',
          error: function() {
            callback();
          },
          success: function(res) {
            callback(res);
          }
        });
      }
    }

    var codeField = this.codeField;
    var codeClassName = this.codeClassName || "";
    var abbreviationClassName = this.abbreviationClassName || "";

    if (codeField) {
      options["render"] = {
        option: function(data) {
          var abbreviationSpan = "";

          if (abbreviationClassName) {
            abbreviationSpan = "<span class='abbreviation " + abbreviationClassName + "'>" + (data.abbreviation || "&nbsp;") + "</span>";
          }

          return "<span class='selection'><span class='option-prefix " + codeClassName + "'>" + data[codeField] + "</span>" + abbreviationSpan + "<span>" + data[options.labelField] + "</span></span>";
        },
        item: function(data) {
          var abbreviation = "";

          if (abbreviationClassName && data.abbreviation) {
            abbreviation = data.abbreviation + " - ";
          }

          return "<div class='item'>" + data[codeField] + " - " + abbreviation + data[options.labelField] + "</div>";
        }
      };
    }

    $(this.$el).find("select").selectize(options).val(this.value).trigger('change').on('change', function () {
      vm.$emit('input', this.value);
    });

    if (this.dateSensitive) {
      this.handleDateSentitivity = function(event, start_date, end_date) {
        vm.start_date = start_date;
        vm.end_date = end_date;

        var data = {
          q: $(vm.$el).find("select")[0].selectize.query,
          start_date: start_date,
          end_date: end_date
        };

        if (vm.drilldownName && vm.drilldownValue) {
          data[vm.drilldownName] = vm.drilldownValue;
        }

        $(vm.$el).find("select")[0].selectize.clear(true);
        $(vm.$el).find("select")[0].selectize.clearOptions();
        $(vm.$el).find("select")[0].selectize.clearCache();
        $(vm.$el).find("select")[0].selectize.refreshOptions();
        $(vm.$el).find("select")[0].selectize.renderCache['option'] = {};
        $(vm.$el).find("select")[0].selectize.renderCache['item'] = {};

        if (!vm.minLength) {
          $(vm.$el).find("select")[0].selectize.load(function(callback) {
            $.ajax({
              url: vm.url,
              data: data,
              type: 'GET',
              error: function() {
                callback();
              },
              success: function(res) {
                callback(res);
              }
            });
          });
        }
      };

      $(".measure-form").on("dates:changed", this.handleDateSentitivity);
    }
  },
  watch: {
    value: function (value) {
      $(this.$el).find("select")[0].selectize.setValue(value, false);
    },
    options: function (options) {
      $(this.$el).find("select")[0].selectize.clearOptions();
      $(this.$el).find("select")[0].selectize.addOption(options);
      $(this.$el).find("select")[0].selectize.refreshOptions(false);
    },
    drilldownValue: function(newVal, oldVal) {
      if (newVal == oldVal) {
        return;
      }

      this.handleDateSentitivity({}, this.start_date, this.end_date);
    }
  },
  destroyed: function () {
    $(this.$el).find("select").off();
    $(this.$el).find("select")[0].selectize.destroy();

    if (this.dateSensitive) {
      $(".measure-form").off("dates:changed", this.handleDateSentitivity);
    }
  }
});
