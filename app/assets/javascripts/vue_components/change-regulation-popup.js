Vue.component("change-regulation-popup", {
  template: "#change-regulation-popup-template",
  data: function() {
    return {
      sameRegulation: false,
      regulationFullDescription: null,
      currentRegulations: null,
      newRegulation: null,
      regulation_id: null
    };
  },
  props: ["measures", "onClose", "open"],
  mounted: function() {
    var self = this;
    var currentRegulations = {};

    this.measures.filter(function(measure) {
      return measure.regulation;
    }).forEach(function(measure) {
      var regulation = measure.regulation;
      var diff = 0;

      if (currentRegulations[regulation.formatted_id] === undefined) {
        currentRegulations[regulation.formatted_id] = {
          count: 1,
          id: regulation.formatted_id,
          description: regulation.information_text
        };

        diff += 1;
      } else {
        currentRegulations[regulation.formatted_id].count += 1;
      }

      self.currentRegulations = currentRegulations;

      if (diff === 1) {
        var firstRegulation = currentRegulations[self.measures[0].regulation.formatted_id];

        self.sameRegulation = true;
        self.regulationFullDescription = firstRegulation.id + " " + firstRegulation.description + " (" + firstRegulation.count + ")";
      }
    });
  },
  methods: {
    confirmChanges: function() {
      var regulation = this.newRegulation;

      //TODO: display error message?
      if (!regulation) {
        return false;
      }

      this.measures.forEach(function(measure) {
        if (!measure.regulation || measure.regulation.formatted_id != regulation.formatted_id) {
          measure.regulation = regulation;

          if (measure.changes.indexOf("regulation") === -1) {
            measure.changes.push("regulation");
          }
        }
      });

      this.$emit("measures-updated");
      this.onClose();
    },
    triggerClose: function() {
      this.onClose();
    },
    onRegulationSelected: function(object) {
      this.newRegulation = object;
    }
  }
});
