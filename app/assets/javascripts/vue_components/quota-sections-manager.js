Vue.component("quota-sections-manager", {
  template: "#quota-sections-manager-template",
  data: function() {
    return {
      section_types: [
        { id: "annual", label: "Annual" },
        { id: "bi_annual", label: "Bi-annual" },
        { id: "quarterly", label: "Quarterly" },
        { id: "monthly", label: "Monthly" },
        { id: "custom", label: "Custom" }
      ],
      periods: [
        { id: "1_repeating", label: "1 year repeating"},
        { id: "1", label: "1 year" },
        { id: "2", label: "2 years" },
        { id: "3", label: "3 years" },
        { id: "4", label: "4 years" },
        { id: "5", label: "5 years" }
      ],
    };
  },
  props: ["sections"],
  mounted: function() {
    if (this.sections.length === 0) {
      this.addSection();
    }
  },
  methods: {
    addSection: function() {
      this.sections.push({
        type: null, // anual, monthly
        start_date: "",
        period: "1", // 1_repeating, 1, 2, 3, 4, 5
        balance: "",

        staged: false,
        criticality_each_period: false,
        duties_each_period: false,

        duty_expressions: [], // only will be filled IF duties_each_period is FALSE
        critical: false, // only to be used IF criticality_each_period is FALSE
        criticality_threshold: 90, // only to be used IF criticality_each_period is FALSE

        measurement_unit_id: "",
        measurement_unit_qualifier_id: "",

        repeat: false,
        periods: [],

        opening_balances: [
          {
            balance: "",
            critical: false, // only to be used IF criticality_each_period is true
            criticality_threshold: 90, // only to be used IF criticality_each_period is true
            duty_expressions: [] // only will be filled IF duties_each_period is TRUE
          }
        ],

        parent_quota: {
          associate: false,
          order_number: "",
          balances: []
        }
      });
    },
    removeSection: function(index) {
      if (confirm('Are you sure?')) {
        this.sections.splice(index, 1);

        if (this.sections.length === 0) {
          this.addSection();
        }
      }
    }
  }
});
