var shown = false;
var current_student = {};

function toggleHide() {
    var x = document.getElementById("toggleable");
    if (x.style.display === "none") {
        x.style.display = "block";
    } else {
        x.style.display = "none";
    }
}

// called when the "draw flashcard" button is pressed
function drawFlashcard(source) {
  // send an AJAX GET request to the flashcard controller
  $.get(flashcard_url+"?type="+source, function(data, status){
    if (status == "success") {
      // send the returned student object to the populate function
      populateFlashcard(data, source);
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
      $("#student-name").html(current_student.name);
      $("#student-notes").val(current_student.notes);
      hide();
    } else if (source == "equity") {
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

// show the name and notes
function show(){
  $("#flashcard-info").removeClass("hidden");
  shown = true;
}

// hide the name and notes
function hide(){
  $("#flashcard-info").addClass("hidden");
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
