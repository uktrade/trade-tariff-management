var template = "<div class='sub-origin'><slot :availableOptions='availableOptions'></slot></div>";

Vue.component("sub-origin", {
  template: template,
  data: function() {
    return {
      availableOptions: []
    };
  },
  props: ["origin", "already_selected"],
  mounted: function() {
    var self = this;

    // Do not move this to a computed property
    // somehow it creates an infinite loop
    // Fixed by debouncing the function and actively
    // checking if things ACTUALLY changed
    this.updateAvailableOptions = debounce(function() {
      var origin = self.origin;
      var alreadySelectedFiltered = self.already_selected.filter(function(s) {
        return s != origin.id;
      });

      var newOptions = origin.options.filter(function(o) {
        return alreadySelectedFiltered.indexOf(o.geographical_area_id) === -1;
      });

      self.availableOptions = newOptions;
    }, 500, false);

    this.updateAvailableOptions();
  },
  watch: {
    already_selected: function(newVal, oldVal) {
      if (newVal.toString() == oldVal.toString()) {
        return;
      }

      this.updateAvailableOptions();
    }
  }
});
