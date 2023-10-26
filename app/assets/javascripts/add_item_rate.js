// app/assets/javascripts/application.js
$(document).on('cocoon:after-insert', function() {
  console.log("hii");
  $('.nested-fields').on('change', '#product_select', function() {
    var productId = $(this).val();
    var fieldsContainer = $(this).closest('.nested-fields').find('.product_attributes');;

    console.log("hello");

    if (productId) {
      // Make an AJAX request to fetch product details
      $.ajax({
        url: '/products/' + productId + '/details.json',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
          console.log(data);
          fieldsContainer.show()
          $('.product_name').text(data.name);
          $('.product_gst').text(data.gst);
          $('.product_tax_value').text(data.tax_value);
          $('.product_rate').text(data.rate);

        }
      });
    } else {
      $('.product_attributes').hide();
    }
  });
});
