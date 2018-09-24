$(document).ready(function() {
  $(document).on('click', ".open-xml-errors-modal", function(){
    var modal_id = $(this).data('id');
    MicroModal.show('bem-xml-errors-' + modal_id);
  });
});
