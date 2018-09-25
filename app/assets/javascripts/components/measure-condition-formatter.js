window.MeasureConditionFormatter = {
  format: function(mc) {
    var certificate_type_code = mc.certificate_type ? mc.certificate_type.certificate_type_code : "";
    var certificate_code = mc.certificate ? mc.certificate.certificate_code : "";
    var document_code = certificate_type_code + certificate_code;
    var action_code = mc.measure_action ? mc.measure_action.action_code : null;

    var res = [];

    if (mc.component_sequence_number) {
      res = ["" + mc.measure_condition_code.condition_code + mc.component_sequence_number];
    } else {
      res = [ mc.condition_code ];
    }

    var cert_info = document_code.trim();

    if (cert_info) {
      res.push(cert_info);
    }

    if (action_code) {
      res.push(action_code);
    }

    if (res.length === 2) {
      return res.join(" - ")
    } else {
      return res.join(" ")
    }
  }
};
