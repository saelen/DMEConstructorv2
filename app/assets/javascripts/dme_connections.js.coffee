# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
test_connection_href = ''

disable_input_for_test = () ->
  $("#connection_form :input").attr("disabled", true);

disable_submit_for_test = () ->
  $("#edit").removeAttr("href").removeAttr("data-method").addClass("disabled")
  $("#form_submit_btn").addClass("disabled").attr("href", "javascript:void(0)").removeAttr('onclick');
  $("#test_connection_results").attr('class', 'alert alert-info').html('Testing connection please be patient.')

display_test_in_process = () ->
  $("#test_connection_results")
    .attr('class', 'alert alert-info')
    .html('Testing connection please be patient.')

hide_test_in_process = () ->
  $("#test_connection_results").attr('class', '').html('')


adjust_link = () ->
  $("#test_connection").attr('href', test_connection_href +
  '?adapter=' + encodeURIComponent($("#dme_connection_adapter").val()) +
  '&host=' + encodeURIComponent($("#dme_connection_host").val()) +
  '&defaultdatabase=' + encodeURIComponent($("#dme_connection_default_database").val()) +
  '&username=' + encodeURIComponent($("#dme_connection_username").val()) +
  '&password=' + encodeURIComponent($("#dme_connection_password").val()) +
  '&name=' + encodeURIComponent($("#dme_connection_name").val())
  )

$(document).ready ->
  test_connection_href = $("#test_connection").attr('href')
  adjust_link()

$(document).ready ->
  $("#test_connection").click (event) ->
    disable_submit_for_test()
    disable_input_for_test()
    display_test_in_process()

$(document).ready ->
  $("form :input").on "change keypress keyup", ->
    adjust_link()
    disable_submit_for_test()
    hide_test_in_process()

