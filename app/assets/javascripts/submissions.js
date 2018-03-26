var selectedStudent = null;
// when the window loads, we give the email box an event listener, so when its value is changed, searchStudents will be called
$( document ).ready(function() {
  var searchBox = $("#name");
  searchBox.on("input", searchStudents);
  searchStudents(); // initially populate the list
  var startingID = $("#id-field").val(); // the id if the form is prepopulated
  if (startingID != null){
    handleNameClick(startingID);
  }
})

function submitForm(){
  var file = $("#answer_file")[0].files[0];
  var data = new FormData();
  data.append("answer", file);
  data.append("student_id", selectedStudent);
  console.log(data);
  //Submit the form via Ajax POST request:
  $.ajax({
    type: 'POST',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}, // needed so that rails will accept the post
    url:  submitURL,
    data:  data,
    processData: false,
    contentType: false,
  }).done(function(data) {
    //The code below is executed asynchronously, 
    //meaning that it does not execute until the
    //Ajax request has finished, and the response has been loaded.
    //This code may, and probably will, load *after* any code that
    //that is defined outside of it.
    alert("Thanks for the submission!");
    console.log("Response Data" +data); //Log the server response to console
  });
  return false;
}

// send an AJAX request for a list of names corresponding to this email
function searchStudents(){
  var searchTerm = $("#name").val();
  console.log(searchTerm);
  $.get(searchURL+'?name='+searchTerm, function(data, status){
    if (status == "success") {
      // send the returned student object to the populate function
      populateResults(data);
    }
  });
}
// responds to the user clicking on a name by highlighting that name and filling in the appropriate id to the form
function handleNameClick(id){
  var previouslyHighlighted = $("#student-results-"+selectedStudent)
  if (previouslyHighlighted != null) {
    previouslyHighlighted.attr("style", "color: black;");
  }
  selectedStudent = id;
  var previouslyHighlighted = $("#student-results-"+selectedStudent)
  if (previouslyHighlighted != null) {
    previouslyHighlighted.attr("style", "color: red;");
  }
  $("#id-field").val(id);
}
// creates a line of html to be used in the results table
function studentLine(id, name){
  return "<tr id=student-results-"+id+" onclick='handleNameClick("+id+")'><td>"+name+"</td></tr>"
}
// populate the list with new entries
function populateResults(students) {
  var html = "";
  if (students.length > 0) {
    html = "<table>\n";
    for (i = 0; i < students.length; i++) { 
      html += studentLine(students[i].id, students[i].name);
    }
  } else {
    html = "No student matches that name"
  }
 $("#suggestions").html(html);
  if (selectedStudent != null) { handleNameClick(selectedStudent); } // make sure that reloading the list doesn't undo selection
}