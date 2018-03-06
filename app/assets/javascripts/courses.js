var shown = false;
var current_student;
// called when the "draw flashcard" button is pressed
function drawFlashcard(source) {
  // send an AJAX GET request to the flashcard controller
  $.get(flashcard_url, function(data, status){
    if (status == "success") {
      // send the returned student object to the populate function
      populateFlashcard(data, source);
    }
  });
}

function populateFlashcard(student, source) {
  // if the returned student exists is not empty
  if (student != {}){
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

// show the name and email
function show(){
  $("#student-name").html(current_student.name);
  $("#student-info").html(current_student.email);
  shown = true;
}

// hide the name and email
function hide(){
  $("#student-name").html(".");
  $("#student-info").html(".");
  shown = false;
}