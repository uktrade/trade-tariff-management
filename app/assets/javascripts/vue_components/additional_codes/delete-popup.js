Vue.component("delete-additional-codes-popup", {
  template: "#delete-additional-codes-popup-template",
  props: [
    "records",
    "onClose",
    "open"
  ],
  data: function() {
    return {
      recordsSentToCDSCount: 0,
      recordsNotSentToCDSCount: 0
    }
  },
  mounted: function() {
    this.recordsSentToCDSCount = this.records.filter(function(record){
      return record.sent_to_cds;
    }).length;
    this.recordsNotSentToCDSCount = this.records.filter(function(record){
      return !record.sent_to_cds;
    }).length;
  },
  methods: {
    triggerClose: function(){
      this.onClose();
    },
    confirmDelete: function(){
      this.records.forEach(function(record){
        record.deleted = true;
      });
      this.$emit("records-deleted", this.records);
      this.onClose();
    }
  }
});
