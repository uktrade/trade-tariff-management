//= require jquery
//= require jquery_ujs
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
    if(window.__pagination_metadata.total_count) {
      setTimeout(function () {
        $(window).scrollTop($('.records-table-wrapper').offset().top);
      }, 1000);
    } else if ($('.loading-indicator').length > 0) {
      $(window).scrollTop($('.search__results').offset().top);
    }
  }
});