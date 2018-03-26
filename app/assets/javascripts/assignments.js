var submission = 0;

window.onload = function load(){
  getNewSub();
}

function prevSub(){
  submission -= 1;
  if (submission < 0){ 
    submission += num_subs;
  }
  getNewSub();
}
 
function nextSub(){
  submission += 1;
  if (submission >= num_subs){ 
    submission -= num_subs;
  }
  getNewSub();
}

function getNewSub() {
  $.get(submissionURL+'?submission='+submission, function(data, status){
    if (status == "success") {
      // send the returned student object to the populate function
      populateSub(data);
    }
  });
}

function populateSub(submission) {
  if (submission != null){
    $("#submission-student").html(submission.student_name);
    $("#submission-picture").attr("src", submission.picture_url);
    $("#submission-created").html(submission.created);
    $("#submission-edited").html(submission.edited);
    $("#edit-btn").attr("href", submission.url+"/edit");
    $("#delete-btn").attr("href", submission.url);
  } else {

  }
}