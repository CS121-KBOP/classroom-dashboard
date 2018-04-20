// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .
//= require Chart.bundle
//= require chartkick

$(document).ready(function(){
  // disable auto discover
  Dropzone.autoDiscover = false;


  var dropzone = new Dropzone (".dropzone", {
    maxFilesize: 256, // Set the maximum file size to 256 MB
    paramName: "student[portrait]", // Rails expects the file upload to be something like model[field_name]
    addRemoveLinks: false // Don't show remove links on dropzone itself.
  });

  dropzone.on("success", function(file) {
    this.removeFile(file)
    $.getScript("/images")
  })
});
