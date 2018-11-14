Vue.component("grid-column", {
  template: '<div v-html="content" :class="classObj"></div>',
  props: ["column", "item", "changeProp", "primaryKey", "hasError"],
  computed: {
    changed: function() {
      return this.changeProp && this.item.changes && this.item.changes.indexOf(this.changeProp) > -1;
    },
    content: function() {
      if (this.column == this.primaryKey && this.item.clone === true) {
        return "&nbsp;";
      }

      return this.item[this.column];
    },
    classObj: function() {
      var classes = {
        'table__column': true,
        'table__column--highlight': this.changed,
        "has-validation-errors": this.hasError
      };

      classes[this.column + '-column'] = true;

      return classes;
    }
  }
})
