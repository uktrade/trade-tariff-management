Vue.component("approve-decision", {
  template: "#approve-decision-template",
  props: [
    "kind",
    "approve"
  ],
  data: function() {
    var data = {};

    return data;
  },
  mounted: function() {
    var self = this,
        radio = $(this.$el).find("input[type='radio']"),
        parent = $(".approve-form");

    radio.on("change", function() {
      parent.trigger("approve:changed");
    });

    parent.on("approve:changed", function() {
      self.approve.selected = radio.is(":checked");
    });

    if (!$.isEmptyObject(window.__approve_json)) {
      selected_mode = window.__approve_json.mode;

      if (selected_mode.length > 0) {
        $("input[name='approve[mode]']").val(selected_mode);
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
      return "approve-decision-" + this.kind;
    }
  },
  watch: {
    "approve.selected": function(newVal, oldVal) {
      if (newVal) {
        if (this.kind == 'approve') {
          this.showApproveDetailsBlock();

        } else if (this.kind == 'reject') {
          this.showRejectDetailsBlock();

        } else {
          this.hideApproveAndRejectDetailsBlocks();
        }

        $("input.js-approve-decision").val(this.kind);

        if ($(".js-approve-form-export-date-date-picker").hasClass('date-picker-not_initialized')) {
          MainMenuInteractions.scheduleExportToCdsFormInit();
          $(".js-approve-form-export-date-date-picker").removeClass('date-picker-not_initialized');
        }
      }
    },
    "approve.submit_for_approval": function(newVal)  {
      if (!newVal) {
        this.approve.submit_for_approval = null;
      }
    }
  },
  methods: {
    showApproveDetailsBlock: function() {
      $(".js-approve-details-block").removeClass('hidden');
      $(".js-approve-reject-details-block").addClass('hidden');
    },
    showRejectDetailsBlock: function() {
      $(".js-approve-reject-details-block").removeClass('hidden');
      $(".js-approve-details-block").addClass('hidden');
    },
    hideApproveAndRejectDetailsBlocks: function() {
      $(".js-approve-details-block").removeClass('hidden');
      $(".js-approve-reject-details-block").removeClass('hidden');
    }
  }
});
