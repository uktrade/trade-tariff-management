Vue.component("change-footnotes-popup", {
  template: "#change-footnotes-popup-template",
  props: ["measures", "onClose", "open"],
  data: function(){
    return {
      uniqMeasuresFootnotes: [],
      measuresFootnotes: [],
      onlyOneMeasure: false,
      confirmBtnDisabled: true,
      updateMode: null,
      hideUpdateMode: false,
      hasChanged: false,
      beforeRender: true
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
      this.hasChanged = true;
    },
    hasChanged: function(){
      this.confirmBtnDisabled = false;
    },
    measuresFootnotes: {
      handler: function(){
        if (!this.confirmBtnDisabled) { return; }
        var anyFootnote = this.measuresFootnotes.some(function(footnote){
          return footnote.footnote_type_id && footnote.description;
        });
        if (anyFootnote && !this.beforeRender) { this.hasChanged = true; }
        if (this.beforeRender) { this.beforeRender = false; }
      },
      deep: true
    }
  },
  mounted: function(){
    var allMeasuresFootnotes = this.measures.reduce(function(map, measure){
      return map.concat(measure.footnotes);
    }, []);
    this.uniqMeasuresFootnotes = allMeasuresFootnotes.reduce(function(memo, footnote){
      var existsInMemo = memo.some(function(filteredFootnote){
        return filteredFootnote.footnote_id == footnote.footnote_id && filteredFootnote.footnote_type_id == footnote.footnote_type_id;
      });
      if (!existsInMemo) {
        var footnoteClone = Object.assign({}, footnote);
        return memo.concat(footnoteClone);
      }
      return memo;
    }, []);

    if (this.uniqMeasuresFootnotes.length == 1) {
      this.measuresFootnotes = this.uniqMeasuresFootnotes;
      this.onlyOneMeasure = true;
    }

    if (allMeasuresFootnotes.length == 0) {
      this.hideUpdateMode = true;
    }

    if (this.measuresFootnotes.length == 0) {
      this.addFootnote();
    }
  }
});
