// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets

$( function() {
  $("#bg img").one("load", function() {
    resize_window();
  }).each(function() {
    if(this.complete) $(this).load();
  });
  $(window).resize( resize_window );
});

var resize_window = function() {
  var i = $("#bg img");
  var i_aspect = i.width() / i.height()
  var w_aspect = $(window).width() / $(window).height();
  var scale=1.0;

  if( i_aspect < w_aspect ) {
    scale = $(window).width() / i.width();
  } else {
    scale = $(window).height() / i.height();
  }
  scale *= 1.05;

  var dx =  ($(window).width()/2) - (i.width()/2);
  var dy = ($(window).height()/2) - (i.height()/2);
  // dy += 70; // navbar height

  i.css( "transform", "scale(" + scale + ")" ).
    css( "margin-left", dx ).
    css( "margin-top", dy ).
    css( "opacity", 1 );

  $("#bg .zoomer").addClass( "pan" );
}