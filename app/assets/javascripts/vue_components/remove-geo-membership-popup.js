Vue.component("remove-geo-membership-popup", {
  template: '#remove-geo-membership-popup-template',
  props: [
      "onClose",
      "open",
      "remove",
      "membership"
  ],
  data: function() {
    return {
      valid: true,
      errors: [],
      processing: false,
    };
  },
  methods: {
    deleteMembership: function() {
      this.remove(this.membership);
      this.onClose();
    },
    triggerClose: function() {
      this.onClose();
    }
  }
});
