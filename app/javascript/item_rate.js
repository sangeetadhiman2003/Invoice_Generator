$(document).ready(function() {
  debugger;
  $('#item_name').on('change', function() {
  var selectedItem = $(this).val();
  var productData = {
  'Laptop': 10000.99, // Map items to rates here
  'Mobile': 19000.99,
  'Watch': 5000.99
  };

  if (selectedItem) {
    debugger;
  $('#rate-field').val(productData[selectedItem]);
  } else {
  $('#rate-field').val('0');
  }
  });
 });
