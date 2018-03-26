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
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    console.log(this.status);
    if (this.readyState == 4 && this.status == 200) {
     populateSub(this.responseText)
    }
  };
  xhttp.open("GET", submissionURL+'?submission='+submission, true);
  xhttp.send();
}

function populateSub(json) {
  if (json != "{}"){
    var submission = JSON.parse(json);
    document.getElementById("submission-student").innerHTML = submission.student_name;
    document.getElementById("submission-picture").src = submission.picture_url;
    document.getElementById("submission-created").innerHTML = submission.created;
    document.getElementById("submission-edited").innerHTML = submission.edited;

  }
}