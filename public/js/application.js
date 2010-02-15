$(function() {

  /* Global ajax setup
    * Add accept-headers
  */
  $.ajaxSetup({
    beforeSend: function (xhr) {
      xhr.setRequestHeader("Accept", "text/javascript");
    }
  });

});