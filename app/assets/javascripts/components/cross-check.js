$(document).ready(function() {
  $("input:radio[name=\"cross_check[mode]\"]").click(function() {
    if ($(this).val() === "approve") {
      $("#cross-check-rejection-reason").addClass("hidden");
      $("#rejection_reason").prop("required",false);
    } else {
      $("#cross-check-rejection-reason").removeClass("hidden");
      $("#rejection_reason").prop("required",true);
    }
  });
  $("input:radio[name=\"approve[mode]\"]").click(function() {
    if ($(this).val() === "approve") {
      $("#approval-rejection-reason").addClass("hidden");
      $("#approve_reject_reasons").prop("required",false);
    } else {
      $("#approval-rejection-reason").removeClass("hidden");
      $("#approve_reject_reasons").prop("required",true);
    }
  });
});
