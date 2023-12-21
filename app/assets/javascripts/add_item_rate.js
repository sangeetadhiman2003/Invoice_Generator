$(document).on('turbolinks:load', function() {
  console.log("hello");
  // Attach event handlers to existing items
  $('.nested-fields .product-select').on('change', function() {
    handleProductSelection($(this));
  });


$(document).on('cocoon:after-insert', function(e, insertedItem) {
  console.log("hello...add_rate_cocoon gem");
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
  const nameFields = document.querySelectorAll(".name-field");

  nameFields.forEach(function(nameField) {
    nameField.addEventListener("input", function() {
      const inputValue = nameField.value;
      if (inputValue.length > 0) {
        nameField.value = inputValue.charAt(0).toUpperCase() + inputValue.slice(1);
      }
    });
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

document.addEventListener('turbolinks:load', function() {
  const deselectAllButton = document.getElementById('deselect-all-button');
  const userCheckboxes = document.querySelectorAll('input[name="user_ids[]"]');

  deselectAllButton.addEventListener('click', function() {
    userCheckboxes.forEach(function(checkbox) {
      checkbox.checked = false;
    });
  });
});

document.addEventListener('turbolinks:load', function() {
  $('#select-all-checkbox').click(function() {
    // Toggle the selection state of all user checkboxes
    $('.user-checkbox').prop('checked', this.checked);
  });


  $('#deselect_all_checkbox').change(function() {
    var isChecked = $(this).prop('checked');
    $('.item_checkbox').prop('checked', !isChecked);
  });

});

document.addEventListener('turbolinks:load', function() {
  const deselectAllButton = document.getElementById('deselect-all-button');
  const userCheckboxes = document.querySelectorAll('input[name="invoice_ids[]"]');

  deselectAllButton.addEventListener('click', function() {
    userCheckboxes.forEach(function(checkbox) {
      checkbox.checked = false;
    });
  });
});

document.addEventListener('DOMContentLoaded', function() {
  var layoutSelect = document.getElementById('layout_select');
  var layoutHiddenInput = document.getElementById('layout_hidden_input');
  var generatePdfLink = document.getElementById('generate_pdf_link');

  layoutSelect.addEventListener('change', function() {
    var selectedLayout = layoutSelect.value;
    console.log('Selected Layout:', selectedLayout); // Add this line
    generatePdfLink.dataset.layout = selectedLayout;

    layoutHiddenInput.value = selectedLayout;
    console.log(layoutHiddenInput.value);

    // Update the data-layout attribute of the "Generate PDF" button
    generatePdfLink.dataset.layout = selectedLayout;

  });
});
