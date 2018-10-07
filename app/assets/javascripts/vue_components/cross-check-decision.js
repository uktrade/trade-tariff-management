Vue.component("cross-check-decision", {
  template: "#cross-check-decision-template",
  props: [
    "kind",
    "cross_check"
  ],
  data: function() {
    var data = {};

    return data;
  },
  mounted: function() {
    var self = this,
        radio = $(this.$el).find("input[type='radio']"),
        parent = $(".cross-check-form");

    radio.on("change", function() {
      parent.trigger("cross_check:changed");
    });

    parent.on("cross_check:changed", function() {
      self.cross_check.selected = radio.is(":checked");
    });

    if (!$.isEmptyObject(window.__cross_check_json)) {
      selected_mode = window.__cross_check_json.mode;

      if (selected_mode.length > 0) {
        $("input[name='cross_check[mode]']").val(selected_mode);
      }
    }
  },
  computed: {
    approveTypeSelected: function() {
      return this.kind == "approve";
    },
    rejectTypeSelected: function() {
      return this.kind == "reject";
    },
    radioID: function() {
      return "cross-check-decision-" + this.kind;
    }
  },
  watch: {
    "cross_check.selected": function(newVal, oldVal) {
      if (newVal) {
        if (this.kind == 'approve') {
          this.showApproveDetailsBlock();

        } else if (this.kind == 'reject') {
          this.showRejectDetailsBlock();

        } else {
          this.hideApproveAndRejectDetailsBlocks();
        }

        $("input.js-cross-check-decision").val(this.kind);
      }
    },
    "cross_check.submit_for_approval": function(newVal)  {
      if (!newVal) {
        this.cross_check.submit_for_approval = null;
      }
    }
  },
  methods: {
    showApproveDetailsBlock: function() {
      $(".js-cross-check-approve-details-block").removeClass('hidden');
      $(".js-cross-check-reject-details-block").addClass('hidden');
    },
    showRejectDetailsBlock: function() {
      $(".js-cross-check-reject-details-block").removeClass('hidden');
      $(".js-cross-check-approve-details-block").addClass('hidden');
    },
    hideApproveAndRejectDetailsBlocks: function() {
      $(".js-cross-check-approve-details-block").removeClass('hidden');
      $(".js-cross-check-reject-details-block").removeClass('hidden');
    }
  }
});
