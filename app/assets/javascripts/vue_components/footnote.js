Vue.component("foot-note", {
  template: "#footnote-template",
  props: ["footnote"],
  data: function() {
    return {
      suggestions: [],
      lastSuggestionUsed: null
    };
  },
  computed: {
    hasSuggestions: function() {
      return this.suggestions.length > 0;
    }
  },
  mounted: function() {
    this.fetchSuggestions = debounce(this.fetchSuggestions.bind(this), 100, false);
  },
  methods: {
    fetchSuggestions: function() {
      var self = this;
      var type_id = this.footnote.footnote_type_id;
      var description =  this.footnote.description.trim();

      this.suggestions.splice(0, 999);

      if (description.length < 1) {
        return;
      }

      $.ajax({
        url: "/footnotes",
        data: {
          footnote_type_id: type_id,
          description: description
        },
        success: function(data) {
          self.suggestions = data;
        }
      });
    },
    useSuggestion: function(suggestion) {
      this.lastSuggestionUsed  = suggestion;
      this.footnote.description = suggestion.description;
      this.suggestions.splice(0, 999);
    }
  },
  watch: {
    "footnote.description": function(newVal, oldVal) {
      if (this.lastSuggestionUsed && newVal === this.lastSuggestionUsed.description) {
        return;
      }

      this.fetchSuggestions();
    }
  }
});
