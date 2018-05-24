var template = [
  "<div class='button-dropdown' :class='{ open: open}'>",
    "<button v-on:click.prevent='toggle'>",
      "<slot name='text'>Default text</slot>",
    "</button>",
    "<slot></slot>",
  "</div>"
].join("");

Vue.component("button-dropdown", {
  template: template,
  data: function() {
    return {
      open: false
    };
  },
  methods: {
    toggle: function() {
      this.open = !this.open;
    },
    close: function() {
      this.open = false;
    }
  },
  mounted: function() {
    var el = this.$el;
    var self = this;

    this.handleOutsideClick = function(e) {
      if (!e.target.matches("a") && $(e.target).closest($(el)).length < 1) {
        this.close();
      }
    }.bind(this);

    $(document).on("click", this.handleOutsideClick);
  },
  destroyed: function() {
    $(document).off("click", this.handleOutsideClick);
  }
});
