$(document).ready(function() {
  $('#item_name').on('change', function() {
    console.log(this)
  var selectedItem = $(this).val();
  var productData = {
  'Laptop': 10000.99, // Map items to rates here
  'Mobile': 19000.99,
  'Watch': 5000.99
  };

  console.log(productData)

  if (selectedItem) {
    debugger;
  $('#rate-field').val(productData[selectedItem]);
  } else {
  $('#rate-field').val('0');
  }
  });
 });
