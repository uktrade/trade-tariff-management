Vue.component("measure-origin", {
  template: "#measure-origin-template",
  props: [
    "placeholder",
    "kind",
    "origin"
  ],
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
      return this.kind !== "country" && !!this.origin.geographical_area_id;
    }
  },
  watch: {
    "origin.geographical_area_id": function(newVal) {
      this.origin.exclusions.splice(0, 999);

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
          this.addExclusion();
        }
      } else {
        this.origin.geographical_area_id = null;
      }
    }
  },
  methods: {
    addExclusion: function() {
      this.origin.exclusions.push({
        geographical_area_id: null,
        options: window.geographical_areas_json[this.origin.geographical_area_id]
      });
    },
    removeExclusion: function(exclusion) {
      var index = this.origin.exclusions.indexOf(exclusion);

      if (index === -1) {
        return;
      }

      this.origin.exclusions.splice(index, 1);
    },
    geographicalAreaChanged: function(newGeographicalArea) {
      this.origin.geographical_area = newGeographicalArea;
    }
  }
});
