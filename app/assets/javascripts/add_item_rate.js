$(document).on('turbolinks:load', function() {
  // Attach event handlers to existing items
  $('.nested-fields .product-select').on('change', function() {
    handleProductSelection($(this));
  });


$(document).on('cocoon:after-insert', function(e, insertedItem) {
  var select = insertedItem.find('.product-select');
  select.on('change', function() {
    handleProductSelection(select);

  });
});

function handleProductSelection(select) {
  var productId = select.val();
  var fieldsContainer = select.closest('.nested-fields').find('.product_attributes');

  if (productId) {
    // Make an AJAX request to fetch product details
    $.ajax({
      url: '/products/' + productId + '/details.json',
      type: 'GET',
      dataType: 'json',
      success: function(data) {
        fieldsContainer.show();
        select.closest('.nested-fields').find('.product_name').text(data.name);
        select.closest('.nested-fields').find('.product_rate').text(data.rate);
        select.closest('.nested-fields').find('.product_tax_value').text(data.tax_value);
        select.closest('.nested-fields').find('.product_gst').text(data.gst);
      }
    });
  } else {
    fieldsContainer.hide();
  }
}
});


document.addEventListener("DOMContentLoaded", function() {
  const nameField = document.getElementById("name-field");

  nameField.addEventListener("input", function() {
    const inputValue = nameField.value;
    if (inputValue.length > 0) {
      nameField.value = inputValue.charAt(0).toUpperCase() + inputValue.slice(1);
    }
  });
});


$(document).ready(function() {
  $('#user_search').on('input', function() {
    var searchTerm = $(this).val();
    var matchedOption = $('#userDatalistOptions option[value="' + searchTerm + '"]');

    if (matchedOption.length > 0) {
      $('#selected_user').val(matchedOption.data('id'));
    } else {
      // Clear the hidden field if no match is found
      $('#selected_user').val('');
    }
  });
});

$(document).ready(function() {
  $('#clients_search').on('input', function() {
    var searchTerm = $(this).val();
    var matchedOption = $('#clientDatalistOptions option[value="' + searchTerm + '"]');

    if (matchedOption.length > 0) {
      $('#selected_clients').val(matchedOption.data('id'));
    } else {
      // Clear the hidden field if no match is found
      $('#selected_clients').val('');
    }
  });
});
