var currentSubmission = 0;
var currentData = [];
var timer = 0; // the timerId for the timeout function

function prevSub(){
  currentSubmission -= 1;
  if (currentSubmission < 0){ 
    currentSubmission += currentData.length;
  }
  setDisplay(currentSubmission);
}
 
function nextSub(){
  currentSubmission += 1;
  if (currentSubmission >= currentData.length){ 
    currentSubmission -= currentData.length;
  }
  setDisplay(currentSubmission);
}

function getData() {
  $.get(submissionURL, function(data, status){
    if (status == "success") {
      // send the returned student object to the populate function
      currentData = data;
      populateTable();
      setDisplay(currentSubmission);
      timer = setTimeout(getData, 5000);
    }
  });
}

function populateTable(){
  rows = "";
  for (i = 0; i< currentData.length; i++){
    submission = currentData[i];
    rows += "<tr class= 'row' onclick='setDisplay("
    rows += i + ")'><td class='col-lg-10 submission-table-name'>";
    rows += submission.student_name;
    rows += "</td><td class='col-lg-2 submission-table-check'>";
    if (submission.submitted){
      rows += "<span class='glyphicon glyphicon-ok'></span>"
    } else {
      rows += "<span class='glyphicon glyphicon-remove'></span>"
    }
    rows += "</td></tr>\n";
  }
  $("#submission-table-body").html(rows);
}

// Set the left display area to submission num
function setDisplay(num) {
  sub = currentData[num]
  if (sub.submitted) {
    $("#submission-student").html(sub.student_name);
    $("#submission-picture").attr("src", sub.picture_url);
    $("#submission-created").html(sub.created);
    $("#submission-edited").html(sub.edited);
    $("#edit-btn").attr("href", sub.url+"/edit");
    $("#delete-btn").attr("href", sub.url);
    $("#edit-btn").removeClass("hidden");
    $("#delete-btn").removeClass("hidden");
  } else {
    $("#submission-student").html(sub.student_name);
    $("#submission-picture").attr("src", "");
    $("#submission-created").html("No Submission Yet");
    $("#submission-edited").html("---");
    $("#edit-btn").addClass("hidden");
    $("#delete-btn").addClass("hidden");
  }
}
