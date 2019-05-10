var template = '<div :class="classObj"><slot v-bind:error="error" v-bind:hasError="hasError"></slot></div>';

Vue.component("form-group", {
  template: template,
  props: ["errors", "errorKey", "classes"],
  computed: {
    classObj: function() {
      var classes = {'form-group': true, 'form-group-error': this.hasError};

      if (this.classes) {
        classes[this.classes] = true;
      }

      return classes;
    },
    hasError: function() {
      return !!this.error;
    },
    error: function() {
      return this.errors ? this.errors[this.errorKey] : null;
    }
  }
});
