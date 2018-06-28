Vue.component("change-origins-popup", {
  template: "#change-origins-popup-template",
  data: function() {
    return {
      differing: false,
      originName: null,
      exclusionsString: null,
      joinedOrigins: null,
      joinedExclusions: null,
      origins: {
        country: {
          geographical_area_id: null,
          exclusions: [],
          selected: false
        },
        group: {
          geographical_area_id: null,
          exclusions: [],
          selected: false
        },
        erga_omnes: {
          geographical_area_id: null,
          exclusions: [],
          selected: false
        }
      }
    };
  },
  props: ["measures", "onClose", "open"],
  mounted: function() {
    var self = this;
    var origins = {};
    var exclusions = {};

    this.measures.forEach(function(measure) {
      if (origins[measure.geographical_area.geographical_area_id] === undefined) {
        origins[measure.geographical_area.geographical_area_id] = {
          area: measure.geographical_area,
          count: 1
        };
      } else {
        origins[measure.geographical_area.geographical_area_id].count++;
      }

      measure.excluded_geographical_areas.forEach(function(ega) {
        if (exclusions[ega.geographical_area_id] === undefined) {
          exclusions[ega.geographical_area_id] = {
            area: ega,
            count: 1
          };
        } else {
          exclusions[ega.geographical_area_id].count++;
        }
      });
    });

    Object.keys(origins).forEach(function(k) {
      if (origins[k].count != self.measures.length) {
        self.differing = true;
      }
    });

    Object.keys(exclusions).forEach(function(k) {
      if (exclusions[k].count != self.measures.length) {
        self.differing = true;
      }
    });

    if (this.differing) {
      this.joinedOrigins = Object.keys(origins).map(function(k) {
        return origins[k];
      }).map(function(origin) {
        return origin.area.geographical_area_id + " " + origin.area.description + "(" + origin.count + ")";
      }).join(", ");

      this.joinedExclusions = Object.keys(exclusions).map(function(k) {
        return exclusions[k];
      }).map(function(exclusion) {
        return exclusion.area.geographical_area_id + " " + exclusion.area.description + "(" + exclusion.count + ")";
      }).join(", ");
    } else {
      this.originName = this.measures[0].geographical_area.description;
      this.exclusionsString = this.measures[0].excluded_geographical_areas.map(function(ega) {
        return ega.geographical_area_id;
      }).join(", ");
    }
  },
  methods: {
    confirmChanges: function() {
      var newOrigin = this.newOrigin;
      var newExclusions = this.newExclusions;

      this.measures.forEach(function(measure) {
        if (measure.changes.indexOf("geographical_area") === -1) {
          measure.changes.push("geographical_area");
        }

        measure.geographical_area = newOrigin;

        if (newExclusions) {

        }
      });

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
