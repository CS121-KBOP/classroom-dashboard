var shown = false;
var current_student = {};
// called when the "draw flashcard" button is pressed
function drawFlashcard(source) {
  // send an AJAX GET request to the flashcard controller
  $.get(flashcard_url, function(data, status){
    if (status == "success") {
      // send the returned student object to the populate function
      console.log(data);
      if (source=="quiz")

        populateFlashcard(data.quiz, source);
      else
        populateFlashcard(data.equity, source);
      end
    }
  });
}

function populateFlashcard(student, source) {
  // if the returned student exists is not empty
  if (!$.isEmptyObject(student)){
    // save the current student
    current_student = student;
    // populate the fields
    $("#student-name").html(student.name);
    $("#student-info").html(student.email);
    $("#student-picture").attr("src", student.portrait_url);
    $("#student-picture").attr("alt", student.name);
    // if this is on the quiz, hide the name and email immediately. 
    if (source == "quiz") {
      hide();
    } else if (source == "dashboard") {
      $("#student-notes").val(student.notes);
    }
  }
}

// switch on/off the name and email
function toggleShow(){
  if (shown) {
    hide();
  } else {
    show();
  }
}

// show the name, email, and notes
function show(){
  $("#student-name").html(current_student.name);
  $("#student-info").html(current_student.email);
  $("#student-notes").html(current_student.notes);
  shown = true;
}

// hide the name, email, and notes
function hide(){
  $("#student-name").html(".");
  $("#student-info").html(".");
  $("#student-notes").html(".");
  shown = false;
}

// called when the notes text field is updated
function updateNotes(){
  // if we are looking at a student
  if (!$.isEmptyObject(current_student)){
    // get the new notes
    var text = $("#student-notes").val();
    // send a post request
    $.ajax({
        type: "POST",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}, // needed so that rails will accept the post
        url: note_upload_url,
        data: { student_id: current_student.id, notes: text },
      });
  }
}
