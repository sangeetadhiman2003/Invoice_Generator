$(document).ready(function() {
  $('#invoice_items_attributes_0_name').on('change', function() {
  var selectedOption = $(this).val();
  var rateField = $('#item_rate');
  var taxField = $('#tax_value');
  var gstField = $('#gst_value');


  // Implement dynamic behavior based on the selected option
  if (selectedOption === 'Laptop') {
  rateField.val('45000');
  taxField.val('50');
  gstField.val('15');

  } else if (selectedOption === 'Mobile') {
  rateField.val('25000');
  taxField.val('20');
  gstField.val('10');
  } else if (selectedOption === 'Watch') {
  rateField.val('5000');
  taxField.val('15');
  gstField.val('5');
  } else {
  rateField.val(''); // Clear the rate field if no option is selected
  }
  });
 });
