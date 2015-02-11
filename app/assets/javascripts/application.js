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
//= require turbolinks
//= require underscore
//= require gmaps/google

var ready;
ready = function() {

    var rooms = document.getElementById('rooms');
    var accommodations = document.getElementById('accommodations');

    if (rooms == null && accommodations === null) {
        var content = document;
        var contentHeight = Math.max(
            content.body.scrollHeight, content.documentElement.scrollHeight,
            content.body.offsetHeight, content.documentElement.offsetHeight,
            content.body.clientHeight, content.documentElement.clientHeight
        );

        var viewPortHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)

        console.log("Content height: " + contentHeight);
        console.log("ViewPort height: " + viewPortHeight);

        if (contentHeight <= viewPortHeight) {
            var d = document.getElementById('footer');
            d.style.position = "absolute";
        }
    }

};

$(document).ready(ready);
$(document).on('page:load', ready);