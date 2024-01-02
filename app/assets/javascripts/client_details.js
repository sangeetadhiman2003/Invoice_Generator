$(document).on('turbolinks:load', function() {
  console.log("hello..client's js");
  $('#client_select').on('change', function() {
    console.log("hello..client's js");
    var clientId = $(this).val();
    var clientAttributes = $(this).closest('.fields').find('#clients_attributes');
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
      clientAttributes.hide();
    }
  });
});
