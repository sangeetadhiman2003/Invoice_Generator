$(document).on('turbolinks:load', function() {
  $('#product_select').on('change', function() {
    var productId = $(this).val();
    var productAttributes = $(this).closest('.fields').find('#product_attributes');
    if (productId) {
      console.log("hello");
      $.ajax({
        url: '/products/' + productId + '/details.json',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
          console.log(data);
          productAttributes.show();
          $('#product_name').text(data.name);
          $('#product_gst').text(data.gst);
          $('#product_tax_value').text(data.tax_value);
          $('#product_rate').text(data.rate);

        }
      });
    } else {
      $('#product_attributes').hide();
    }
  });
});










// $(document).on('ready turbolinks:load', function() {
//   console.log("hello");
//   $('#dynamic_select').on('change', function() {
//     console.log("hello2");
//   var selectedOption = $(this).val();
//   var rateField = $('#item_rate');
//   var taxField = $('#tax_value');
//   var gstField = $('#gst_value');


//   // Implement dynamic behavior based on the selected option
//   if (selectedOption === 'Laptop') {
//   rateField.val('45000');
//   taxField.val('50');
//   gstField.val('15');

//   } else if (selectedOption === 'Mobile') {
//   rateField.val('25000');
//   taxField.val('20');
//   gstField.val('10');
//   } else if (selectedOption === 'Watch') {
//   rateField.val('5000');
//   taxField.val('15');
//   gstField.val('5');
//   } else {
//   rateField.val(''); // Clear the rate field if no option is selected
//   }
//   });
//  });


// //add item using add_item_field
