# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#dme_table_connection_id").on "change", ->
    $.getJSON "/connections/database_list.json?id=" + $("#dme_table_connection_id").val(), (dblist) ->
      $("#dme_table_database_name").children().remove()
      $.each dblist, ->
        $("#dme_table_database_name").append($("<option />").val(this).text(this))

$(document).ready ->
  $("#dme_table_database_name").on "change", ->
    $.getJSON "/connections/table_list.json?id=" + $("#dme_table_connection_id").val() + "&dbname=" + $("#dme_table_database_name").val(), (tablelist) ->
      $("#dme_table_table_name").children().remove()
      $.each tablelist, ->
        $("#dme_table_table_name").append($("<option />").val(this).text(this))

#$(document).ready ->
#  $("a#edit_table_tab")
#    .bind("ajax:success", (evt, data, status, xhr) ->
#      $("#dme").html(xhr.responseText)
#     # $(this).parent().addClass("active")
#    )

#$(document).ready ->
#  $("a[data-toggle=\"tab\"]").on "shown", (e) ->
#    alert('Dirt')