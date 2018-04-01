var currentSubmission = 0;

$(document).ready(function() {
  if (page == "assignment"){
    getNewSub();
  }
});

function prevSub(){
  currentSubmission -= 1;
  if (currentSubmission < 0){ 
    currentSubmission += numSubs;
  }
  getNewSub();
}
 
function nextSub(){
  currentSubmission += 1;
  if (currentSubmission >= numSubs){ 
    currentSubmission -= numSubs;
  }
  getNewSub();
}

function getNewSub() {
  $.get(submissionURL+'?submission='+currentSubmission, function(data, status){
    if (status == "success") {
      // send the returned student object to the populate function
      populateSub(data);
    }
  });
}

function populateSub(sub) {
  if (sub.student_name != null){
    $("#submission-student").html(sub.student_name);
    $("#submission-picture").attr("src", sub.picture_url);
    $("#submission-created").html(sub.created);
    $("#submission-edited").html(sub.edited);
    $("#edit-btn").attr("href", sub.url+"/edit");
    $("#delete-btn").attr("href", sub.url);
  } else {
    $("#submission-student").html("No Submissions Yet");
    $("#submission-created").addClass("hidden");
    $("#submission-edited").addClass("hidden");
  }
}
