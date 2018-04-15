var box = null;

$( document ).ready(function() {
    box = $("#access-box");
    box.on("input", correctAccessTag);
    // if we press enter while in the box, submit
    box.keypress(function (e) {
	  if (e.which == 13) { // char 13 is enter
	    $('#access-button').click();
	    return false;
	  }
	});
});


function correctAccessTag(event){
	var val = box.val();
	val = val.replace(/[^0-9a-z]/gi, ''); // remove all non-alpha chars
	val = val.replace(/[aeiou1234567890]/ig,''); // remove all vowels 
	val = val.slice(0, 5); // take only the first 5 letters
	val = val.toUpperCase();
	box.val(val);
}

function redirectToAssignment(){
	window.location.href = "/"+box.val(); // redirect to the proper page
}