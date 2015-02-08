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
  $("#bg_tag img").one("load", function() {
    scale_images( $(this) );
  }).each(function() {
    if(this.complete) $(this).load();
  });
  $(window).resize( resize_window );
  setTimeout( poll_for_shouts, 8000 );
});

var resize_window = function() {
  $("#bg_tag img").each( function() { scale_images( $(this) ); } );
}

var scale_images = function( i ) {
  var i_aspect = i.width() / i.height()
  var w_aspect = $(window).width() / $(window).height();

  if( i_aspect < w_aspect ) {
    i.removeClass( "taller" ).addClass( "wider" );
  } else {
    i.removeClass( "wider" ).addClass( "taller" );
  }
}

var next_image = function() {
  var current_image = -1;
  var i = 0;

  var stacked_list = $("#bg_tag .stacked");
  stacked_list.each( function() {
    if( $(this).hasClass( "active" ) ) {
      current_image = i;
    }
    i += 1;
  });

  current_image += 1;
  if( current_image > stacked_list.length ) {
    current_image = 0;
  }

  stacked_list.removeClass( "active" );
  $("#bg_tag .stacked:nth(" + current_image + ")").addClass( "active" );
}

var have_thought = function( info ) {

  var html = "<span class='to'>"
  if( info.to_user_id ) {
    html += "<a href='/user/" + info.to_user_id + "'>"
    html += info.to;
    html += "</a>"
  } else {
    html += info.to;
  }
  html += "</span>\n"

  html += info.message;

  html += " <span class='from'>"
  if( info.from_user_id ) {
    html += "<a href='/user/" + info.from_user_id + "''>"
    html += info.from;
    html += "</a>"
  } else {
    html += info.from;
  }
  html += "</span>\n"

  $(".thought").html( html );
  if( Math.random() < .5 ) {
    $(".thought").addClass( "right" );
  } else {
    $(".thought").removeClass( "right" );
  }
  if( Math.random() < .5 ) {
    $(".thought").addClass( "bottom" );
  } else {
    $(".thought").removeClass( "bottom" );
  }
  // $(".thought").fadeIn();
  next_image();
}

var poll_for_shouts = function() {
  // console.log( "polling for shouts");
  $.getJSON( "/next_shout" ).success(function(data) {
    // console.log( data );
    have_thought( data );
    setTimeout( poll_for_shouts, 8000 );
  });
}