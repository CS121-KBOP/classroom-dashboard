var selectedStudent = null;
// when the window loads, we give the email box an event listener, so when its value is changed, searchStudents will be called
$( document ).ready(function() {
  if (page == "submission"){
    console.log("loaded");
    var searchBox = $("#search");
    searchBox.on("input", searchStudents);
    searchStudents(); // initially populate the list
    var startingID = $("#id-field").val(); // the id if the form is prepopulated
    if (startingID != null){
      handleNameClick(startingID);
    }

    // set the text of the file button
    var fileLabel = $("label[for='answer_file']");
    fileLabel.html(fileLabel.attr("empty-caption"));

    // set the text of the file button to change when a file is uploaded
    $("#answer_file").change(function(){
      var submitButton = $("#answer_file");
      if( submitButton[0].files && submitButton[0].files.length > 0 ){
        var fileName = submitButton[0].files[0].name.split( '\\' ).pop();
        $("label[for='answer_file']").html(fileName);
      }
    });
  }
})

// Called when the form is submitted
function submitForm(){
  // Ready the alert handler
  var alert = $("#alert");
  if (selectedStudent == null) {
    // Make the alert bar be shown and red
    alert.removeClass("alert-success");
    alert.removeClass("hidden");
    alert.addClass("alert-danger");
    alert.html("Please select your name");
    return;
  }

  var file = $("#answer_file")[0].files[0];

  if (file == null) {
    // Make the alert bar be shown and red
    alert.removeClass("alert-success");
    alert.removeClass("hidden");
    alert.addClass("alert-danger");
    alert.html("Please select an image to submit");
    return;
  }

  // Create the form data, and add the file and student ID
  var data = new FormData();
  data.append("answer", file);
  data.append("student_id", selectedStudent);

  //Submit the form via Ajax POST request:
  $.ajax({
    type: 'POST',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}, // needed so that rails will accept the post
    url:  submitURL,
    data:  data,
    processData: false,
    contentType: false,
  }).done(function(data) {
    alert.removeClass("alert-danger");
    alert.removeClass("hidden");
    alert.addClass("alert-success");
    alert.html("Submission Received!");

    // Clear the form. wrap/unwrap is a hack to clear the file form
    $("#answer_file").wrap('<form>').closest('form').get(0).reset();
    $("#answer_file").unwrap();

    // unhighlight all student names
    var previouslyHighlighted = $("#student-results-"+selectedStudent)
    if (previouslyHighlighted != null) {
      previouslyHighlighted.removeClass("submission-suggestion-selected");
    }
    // reset ids and search bar
    selectedStudent = null;
    $("#name").val("");

    // reset file button
    var fileLabel = $("label[for='answer_file']");
    fileLabel.html(fileLabel.attr("empty-caption"));

    searchStudents(); // reset search results
  });
}

// send an AJAX request for a list of names corresponding to this name
function searchStudents(){
  var searchTerm = $("#search").val();
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
    previouslyHighlighted.removeClass("submission-suggestion-selected");
  }
  selectedStudent = id;
  var previouslyHighlighted = $("#student-results-"+selectedStudent)
  if (previouslyHighlighted != null) {
    previouslyHighlighted.addClass("submission-suggestion-selected");
  }
  $("#id-field").val(id);
}
// creates a line of html to be used in the results table
function studentLine(id, name){
  return "<div id=student-results-"+id+" class='submission-suggestion' onclick='handleNameClick("+id+")'>"+name+"</div>"
}
// populate the list with new entries
function populateResults(students) {
  var html = "";
  if (students.length > 0) {
    html = "";
    for (i = 0; i < students.length; i++) { 
      html += studentLine(students[i].id, students[i].name);
    }
  } else {
    html = "<br><br>No student matches that name"
  }
 $("#suggestions").html(html);
  if (selectedStudent != null) { handleNameClick(selectedStudent); } // make sure that reloading the list doesn't undo selection
}
