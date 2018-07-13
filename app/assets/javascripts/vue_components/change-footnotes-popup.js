Vue.component("change-footnotes-popup", {
  template: "#change-footnotes-popup-template",
  props: ["measures", "onClose", "open"],
  data: function(){
    return {
      measuresFootnotes: [],
      onlyOneMeasure: false,
      confirmBtnDisabled: true,
      updateMode: null,
      hideUpdateMode: false
    };
  },
  methods: {
    triggerClose: function(){
      this.onClose();
    },
    addFootnote: function() {
      this.measuresFootnotes.push({
        footnote_type_id: null,
        footnote_id: null,
        description: null
      });
    },
    removeFootnote: function(footnote){
      var index = this.measuresFootnotes.indexOf(footnote);

      if (index === -1) { return; }

      this.measuresFootnotes.splice(index, 1);
    },
    confirmChanges: function(){
      var self = this;
      this.measuresFootnotes = this.measuresFootnotes.filter(function(footnote){
        return !!footnote.footnote_id && !footnote.remove;
      });

      this.measures.forEach(function(measure){
        if (measure.footnotes != self.measuresFootnotes) {

          if (self.onlyOneMeasure || self.updateMode == "replace") {
            measure.footnotes = self.measuresFootnotes;
          } else {
            var allFootnotes = self.measuresFootnotes.concat(measure.footnotes);
            measure.footnotes = allFootnotes.reduce(function(memo, footnote){
              var footnoteExists = memo.find(function(fnote){
                return fnote.footnote_id == footnote.footnote_id && fnote.footnote_type_id == footnote.footnote_type_id;
              });
              if (!footnoteExists) {
                memo.push(footnote);
              }
              return memo;
            }, []);
          }

          if (measure.changes.indexOf("footnotes") == -1) {
            measure.changes.push("footnotes");
          }
        }
      });

      this.$emit("measures-updated");
      this.onClose();
    }
  },
  watch: {
    updateMode: function(){
      this.confirmBtnDisabled = false;
    }
  },
  mounted: function(){
    var allMeasuresFootnotes = this.measures.reduce(function(map, measure){
      return map.concat(measure.footnotes);
    }, []);
    var uniqMeasuresFootnotes = allMeasuresFootnotes.filter(function(footnote, index, self){
      return self.indexOf(footnote) == index;
    });

    if (uniqMeasuresFootnotes.length == 1) {
      this.measuresFootnotes = uniqMeasuresFootnotes;
      this.confirmBtnDisabled = false;
      this.onlyOneMeasure = true;
    }

    if (allMeasuresFootnotes.length == 0) {
      this.confirmBtnDisabled = false;
      this.hideUpdateMode = true;
    }

    if (this.measuresFootnotes.length == 0) {
      this.addFootnote();
    }
  }
});
