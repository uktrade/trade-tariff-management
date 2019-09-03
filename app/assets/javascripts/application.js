//= require ./polyfills/polyfill.min
//= require ./polyfills/matches
//= require jquery
//= require jquery_ujs
//= require cable
//= require FileSaver
//= require moment
//= require pikaday
//= require parsley
//= require selectize
//= require numeral.min
//= require URI.min
//= require dexie
//= require micromodal.min
//= require vue
//= require vue-resource
//= require vue-virtual-scroller.min
//= require ./components/utils
//= require_tree .

$(function () {
  if (window.__pagination_metadata) {
    if (window.__pagination_metadata.total_count) {
      function startTimer() {
        var timer = window.setTimeout(function () {
          try {
            $(window).scrollTop($('.records-table-wrapper').offset().top - 200);
            window.clearTimeout(timer);
          } catch(e) {
            window.clearTimeout(timer);
            startTimer();
          }
        }, 500);
      };
      startTimer();
    } else if ($('.loading-indicator').length > 0) {
      $(window).scrollTop($('.search__results').offset().top - 200);
    }
  }
});

function generateUUID() {
  var S4 = function() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
  };
  return (
    S4() +
    S4() +
    "-" +
    S4() +
    "-" +
    S4() +
    "-" +
    S4() +
    "-" +
    S4() +
    S4() +
    S4()
  );
}
