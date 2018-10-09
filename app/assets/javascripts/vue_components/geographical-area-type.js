Vue.component("geographical-area-type", {
  template: "#geographical-area-type-template",
  props: [
    "kind",
    "geographical_area"
  ],
  data: function() {
    var data = {
      groups_list: window.__geographical_area_groups_json
    };

    return data;
  },
  mounted: function() {
    var self = this,
        radio = $(this.$el).find("input[type='radio']"),
        parent = $(".geographical-area-form");

    radio.on("change", function() {
      parent.trigger("geographical_area:changed");
    });

    parent.on("geographical_area:changed", function() {
      self.geographical_area.selected = radio.is(":checked");
    });

    if (!$.isEmptyObject(window.__geographical_area_json)) {
      selected_geographical_code = window.__geographical_area_json.geographical_code;

      if (selected_geographical_code.length > 0) {
        $("input[name='geographical_area[geographical_code]']").val(selected_geographical_code);
      }
    }

    if (self.geographical_area.selected && this.groupTypeSelected) {
      this.showParentGroupSelector();

      if (!$.isEmptyObject(window.__geographical_area_json)) {
        parent_group_id = window.__geographical_area_json.parent_geographical_area_group_id;

        if (parent_group_id.length > 0) {
          $("select[name='geographical_area[parent_geographical_area_group_id]']")[0].selectize.setValue(parent_group_id);
        }
      }
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
    "geographical_area.geographical_area_id": function(newVal) {
      if (newVal) {
        this.geographical_area.selected = true;
        $(this.$el).find("input[type='radio']").prop("checked", true).trigger("change");
      }
    },
    "geographical_area.selected": function(newVal, oldVal) {
      if (newVal) {
        if (this.kind == 'group') {
          this.showParentGroupSelector();
        } else {
          this.hideParentGroupSelector();
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
    changeParentGroup: function(newParentGroup) {
      this.geographical_area.parent_geographical_area_group_id = newParentGroup;
    }
  }
});
