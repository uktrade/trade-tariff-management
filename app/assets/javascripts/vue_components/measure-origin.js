Vue.component("measure-origin", {
  template: "#measure-origin-template",
  props: [
    "placeholder",
    "kind",
    "origin",
    "multiple"
  ],
  data: function() {
    var data = {
      origins: [{
        type: "country",
        placeholder: "― select a country or region ―",
        id: null,
        options: window.all_geographical_countries,
        key: 1
      }],
      key: 2
    };

    if (this.origin.geographical_area_id instanceof Array && this.origin.geographical_area_id.length > 0) {
      var arr = [];
      var selected_ids = this.origin.geographical_area_id;

      selected_ids.forEach(function(id) {
        var isCountry = window.geographical_areas_json[id].length === 0;
        var exclusions = selected_ids.slice(0).filter(function(e) {
          return e != id;
        });

        var options = isCountry ? window.all_geographical_countries : window.geographical_groups_except_erga_omnes;
        var opts = options.filter(function(o) {
          return exclusions.indexOf(o.geographical_area_id) === -1;
        });

        arr.push({
          type: "country",
          placeholder: isCountry ? "― select a country or region ―" : "― select a group of countries ―",
          id: id,
          key: data.key++,
          options: opts
        });
      });

      data.origins = arr;
    }

    return data;
  },
  mounted: function() {
    var self = this,
        radio = $(this.$el).find("input[type='radio']"),
        parent = $(".measure-form").length > 0 ? $(".measure-form") : $(this.$el.parentElement);

    radio.on("change", function() {
      parent.trigger("origin:changed");
    });

    parent.on("origin:changed", function() {
      self.origin.selected = radio.is(":checked");
    });
  },
  computed: {
    radioID: function() {
      return "measure-origin-" + this.kind;
    },
    notErgaOmnes: function() {
      return this.kind !== "erga_omnes";
    },
    optionsForSelect: function() {
      if (this.kind === "group") {
        return window.geographical_groups_except_erga_omnes;
      } else if (this.kind === "country") {
        return window.all_geographical_countries;
      }
    },
    showExclusions: function() {
      return this.kind !== "country" && this.origin.selected && this.origin.geographical_area_id;
    },
    alreadySelected: function() {
      return this.origins.map(function(o) {
        return o.id;
      });
    }
  },
  watch: {
    "origin.geographical_area_id": function(newVal) {
      if (newVal) {
        this.origin.selected = true;
        $(this.$el).find("input[type='radio']").prop("checked", true).trigger("change");
        this.origin.exclusions.slice(0, 999);
        this.addExclusion();
      }
    },
    "origin.selected": function(newVal, oldVal) {
      if (newVal) {
        if (this.kind === "erga_omnes") {
          this.origin.geographical_area_id = '1011';
        }
      }
    },
    alreadySelected: function() {
      if (!this.multiple) {
        return;
      }

      this.origin.geographical_area_id = this.origins.map(function(o) {
        return o.id;
      });

      this.origin.selected = true;
    }
  },
  methods: {
    addExclusion: function() {
      var options = this.getExclusionOptions(this.origin.geographical_area_id);
      this.origin.exclusions.push({
        geographical_area_id: null,
        options: options,
        uid: new Date().valueOf()
      });
    },
    removeExclusion: function(exclusion) {
      var index = this.origin.exclusions.indexOf(exclusion);

      if (index === -1) {
        return;
      }

      this.origin.exclusions.splice(index, 1);
      this.changeExclusion();
    },
    geographicalAreaChanged: function(newGeographicalArea) {
      this.origin.geographical_area = newGeographicalArea;
    },
    changeExclusion: function(){
      var currentExclusions,
          self = this;
      currentExclusions = this.getCurrentExclusionsArray();
      // reset exclusions:
      this.origin.exclusions.forEach(function(exclusion){
        exclusion.options = window.geographical_areas_json[self.origin.geographical_area_id].slice();
      });
      // remove current exclusions from options:
      currentExclusions.forEach(function(chosenExclusionId){
        self.origin.exclusions.forEach(function(exclusion){
          var selected = exclusion.geographical_area_id == chosenExclusionId;
          if (!selected) {
            var selectedExclusion = exclusion.options.find(function(opt){
              return opt.geographical_area_id == chosenExclusionId;
            });
            var idx = exclusion.options.indexOf(selectedExclusion);
            exclusion.options.splice(idx, 1);
          }
        });
      });
    },
    getCurrentExclusionsArray: function(){
      return this.origin.exclusions.reduce(function(memo, exclusion){
        if (exclusion.geographical_area_id) {
          return memo.concat(exclusion.geographical_area_id);
        }
        return memo;
      }, []);
    },
    getExclusionOptions: function(geographicalAreaId){
      if (this.multiple) {
        return [];
      }

      var currentExclusions = this.getCurrentExclusionsArray(),
          areas = window.geographical_areas_json[geographicalAreaId];
      return areas.slice().filter(function(area){
        return !currentExclusions.includes(area.geographical_area_id);
      });
    },
    addCountryOrTerritory: function() {
      this.origins.push({
        type: "country",
        placeholder: "― select a country or region ―",
        id: null,
        options: window.all_geographical_countries,
        key: this.key++
      });
    },
    addGroup: function() {
      this.origins.push({
        type: "group",
        placeholder: "― select a group of countries ―",
        id: null,
        options: window.geographical_groups_except_erga_omnes,
        key: this.key++
      });
    },
    removeSubOrigin: function(index) {
      this.origins.splice(index, 1);
    }
  }
});
