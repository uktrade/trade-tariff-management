Vue.component("geographical-area-type", {
  template: "#geographical-area-type-template",
  props: [
    "kind",
    "origin"
  ],
  data: function() {
    var data = {};

    return data;
  },
  mounted: function() {
    var self = this,
        radio = $(this.$el).find("input[type='radio']"),
        parent = $(".geographical-area-form");

    radio.on("change", function() {
      parent.trigger("origin:changed");
    });

    parent.on("origin:changed", function() {
      self.origin.selected = radio.is(":checked");
    });

    if (self.origin.selected && this.groupTypeSelected) {
      this.showParentGroupSelector();
    }
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
          this.showParentGroupSelector();
        } else {
          this.hideParentGroupSelector();
          this.cleanUpSelectedParentGroup();
        }

        $("input.js-geographical-area-type").val(this.kind);
      }
    }
  },
  methods: {
    showParentGroupSelector: function() {
      $(".js-geographical-area-parent-group-select-block").removeClass('hidden');
    },
    hideParentGroupSelector: function() {
      $(".js-geographical-area-parent-group-select-block").addClass('hidden');
    },
    cleanUpSelectedParentGroup: function() {
      $("select[name='geographical_area[geographical_area_id]']")[0].selectize.clearOptions();
    },
    changeParentGroup: function(newParentGroup) {
      this.origin.geographical_area_id = newParentGroup;
    }
  }
});
