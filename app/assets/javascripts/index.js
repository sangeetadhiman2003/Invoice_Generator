function addRow() {
  var table = document.getElementById("myTable");

  // Create a new row
  var newRow = table.insertRow(-1);

  // Create cells for the new row
  var cell1 = newRow.insertCell(0);
  var cell2 = newRow.insertCell(1);
  var cell3 = newRow.insertCell(2);
  var cell4 = newRow.insertCell(3);
  var cell5 = newRow.insertCell(4);
  var cell6 = newRow.insertCell(5);

  // Create input fields for each cell
  var input1 = document.createElement("input");
  input1.type = "text";
  input1.name = "new_input1"; // You can set a unique name for each input if needed
  cell1.appendChild(input1);

  var input2 = document.createElement("input");
  input2.type = "text";
  input2.name = "new_input2"; // You can set a unique name for each input if needed
  cell2.appendChild(input2);

  var input3 = document.createElement("input");
  input3.type = "text";
  input3.name = "new_input3"; // You can set a unique name for each input if needed
  cell3.appendChild(input3);

  var input4 = document.createElement("input");
  input4.type = "text";
  input4.name = "new_input4"; // You can set a unique name for each input if needed
  cell4.appendChild(input4);

  var input5 = document.createElement("input");
  input5.type = "text";
  input5.name = "new_input5"; // You can set a unique name for each input if needed
  cell5.appendChild(input5);

  var input6 = document.createElement("input");
  input6.type = "text";
  input6.name = "new_input5"; // You can set a unique name for each input if needed
  cell6.appendChild(input6);

  return false;
 }
