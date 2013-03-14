# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$("#test_connection").click ->
  $("#test_connection_results").attr("class", "alert alert-info").html "<b>Testing Connection please be patient..."
