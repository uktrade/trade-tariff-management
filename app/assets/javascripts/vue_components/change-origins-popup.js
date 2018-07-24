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
          selected: false,
          geographical_area: window.geographical_area_erga_omnes
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
      var newOriginData = this.getNewOriginData(),
          newExclusionsData = this.getNewExclusionsData(newOriginData);

      this.measures.forEach(function(measure) {
        if (measure.changes.indexOf("geographical_area") === -1) {
          measure.changes.push("geographical_area");
        }

        measure.geographical_area = newOriginData.geographical_area;

        if (measure.changes.indexOf("excluded_geographical_areas") === -1) {
          measure.changes.push("excluded_geographical_areas");
        }

        measure.excluded_geographical_areas = newExclusionsData;
      });

      this.$emit("measures-updated");
      this.onClose();
    },
    triggerClose: function() {
      this.onClose();
    },
    onRegulationSelected: function(object) {
      this.newRegulation = object;
    },
    getNewOriginData: function(){
      var self = this;
      var selectedKey = Object.keys(this.origins).find(function(key){
        return self.origins[key].selected;
      });
      return this.origins[selectedKey];
    },
    getNewExclusionsData: function(originData){
      return originData.exclusions.reduce(function(memo, exclusion){
        if (exclusion.geographical_area_id) {
          return memo.concat(exclusion);
        }
        return memo;
      }, []);
    }
  }
});
