$(document).ready(function() {
  setTimeout(function() {
    $(".confirmation-message").each(function() {
      var message = $(this);

      var timeout = setTimeout(function() {
        message.animate({
          opacity: 0,
          top: -30
        }, 500, function() {
          message.remove();
        });
      }, 12000);

      message.find(".close, a").on("click", function() {
        clearTimeout(timeout);

        message.animate({
          opacity: 0,
          top: -30
        }, 500, function() {
          message.remove();
        });
      });
    });
  }, 2000);
});
