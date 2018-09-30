Vue.component("geographical-area-type", {
  template: "#geographical-area-type-template",
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

    return data;
  },
  mounted: function() {
    var self = this,
        radio = $(this.$el).find("input[type='radio']"),
        parent = $(".geographical-area-form").length > 0 ? $(".geographical-area-form") : $(this.$el.parentElement);

    radio.on("change", function() {
      parent.trigger("origin:changed");
    });

    parent.on("origin:changed", function() {
      self.origin.selected = radio.is(":checked");
    });
  },
  computed: {
    countryTypeSelected: function() {
      return this.kind == "country";
    },
    regionTypeSelected: function() {
      return this.kind == "region";
    },
    groupTypeSelected: function() {
      return this.kind == "group";
    },
    radioID: function() {
      return "geographical-area-type-" + this.kind;
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
      }
    },
    "origin.selected": function(newVal, oldVal) {
      if (newVal) {
        if (this.kind == 'group') {
          $(".js-geographical-area-parent-group-select-block").removeClass('hidden');
        } else {
          $(".js-geographical-area-parent-group-select-block").addClass('hidden');
          $("select[name='geographical_area[geographical_area_id]']")[0].selectize.clearOptions();
        }

        $("input.js-geographical-area-type").val(this.kind);
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
    geographicalAreaChanged: function(newGeographicalArea) {
      this.origin.geographical_area = newGeographicalArea;
    },
    changeParentGroup: function(newParentGroup) {
      this.origin.geographical_area_id = newParentGroup;
    }
  }
});
