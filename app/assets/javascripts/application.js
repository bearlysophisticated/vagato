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
//= require moment
//= require bootstrap-datetimepicker
//= require moment-hu/hu

var setupDatePickers = function() {

    var start_date = document.getElementById('booking_start_date') == null ? $('#search_start_date') : $('#booking_start_date');
    var end_date = document.getElementById('booking_end_date') == null ? $('#search_end_date') : $('#booking_end_date');

    if(start_date != undefined && end_date != undefined) {
        start_date.datetimepicker({
            locale: "hu",
            calendarWeeks: true,
            format: "YYYY.MM.DD"
        });
        start_date.data("DateTimePicker").setMinDate(new Date());

        end_date.datetimepicker({
            locale: "hu",
            calendarWeeks: true,
            format: "YYYY.MM.DD"
        });

        start_date.on("dp.change", function (e) {
            end_date.data("DateTimePicker").setMinDate(e.date.add(1, 'days'));
            if(end_date.data("DateTimePicker").date <= e.date){
                end_date.data("DateTimePicker").setDate(e.date);
            }
            setNightsInput();
        });

        /*$('#end_date').on("dp.change", function (e) {
            setNightsInput();
        });

        $('#booking_nights').on("change", function (e) {
            var start_date = $('#start_date').data("DateTimePicker").date;
            console.log("Startdate " + start_date.toString());
            var new_end_date = start_date.add($('#booking_nights').val(), 'days');
            console.log("Enddate " + new_end_date.toString());
            $('#end_date').data("DateTimePicker").setDate(new_end_date);
        });*/
    }
};

function setNightsInput(){
    var nights = $('#booking_end_date').data("DateTimePicker").date.diff($('#booking_start_date').data("DateTimePicker").date, 'days');
    console.log(nights);
    $('#booking_nights').val(nights);
}

var positionFooter = function() {
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
}

var ready = function() {
    positionFooter();
    setupDatePickers();
};

$(document).ready(ready);
$(document).on('page:load', ready);