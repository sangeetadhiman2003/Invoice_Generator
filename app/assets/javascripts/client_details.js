$(document).on('turbolinks:load', function() {
  $('#client_select').on('change', function() {
    var clientId = $(this).val();
    var clientAttributes = $(this).closest('.fields').find( '#clients_attributes');
    if (clientId) {
      console.log("hello");
      $.ajax({
        url: '/clients/' + clientId + '/details.json',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
          console.log(data);
          clientAttributes.show();
          $('#client_name').text(data.name);
          $('#client_address').text(data.address);
          $('#client_phone').text(data.phone);
          $('#client_pan').text(data.pan);
          $('#client_state').text(data.state);

        }
      });
    } else {
      $('#client_attributes').hide();
    }
  });
});
