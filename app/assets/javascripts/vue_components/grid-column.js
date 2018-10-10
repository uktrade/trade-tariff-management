Vue.component("grid-column", {
  template: '<div v-html="content" :class="classObj"></div>',
  data: function() {
    return {

    }
  },
  props: ["column", "item", "changeProp"],
  computed: {
    changed: function() {
      return this.changeProp && this.item.changes && this.item.changes.indexOf(this.changeProp) > -1;
    },
    content: function() {
      return this.item[this.column];
    },
    classObj: function() {
      var classes = {
        'table__column': true,
        'table__column--highlight': this.changed
      };

      classes[this.column + '-column'] = true;

      return classes;
    }
  }
})
