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

hide_all_edit_icons = () ->
  $("input").each ->
    $(this).prop('disabled', true)
    $(this).hide()
  $("tr").each ->
    $(this).removeClass("info").removeClass("no_padding")
  $("a.field_edit").each ->
    $(this).hide()
  $("a.field_save").each ->
    $(this).hide()
  $("a.field_cancel").each ->
    $(this).hide()
  $("span.dme_field_label").each ->
    $(this).show()


restore_edit = () ->
  hide_all_edit_icons()
  $("a.field_edit").each ->
    $(this).show()

$(document).ready ->
  restore_edit()

$(document).ready ->
  $("a.field_edit").on "click", ->
    hide_all_edit_icons()
    $(this).parent("td").parent("tr").addClass("info")
    $(this).parent("td").find("a.field_save").show()
    $(this).parent("td").find("a.field_cancel").show()
    row = $(this).parent("td").parent("tr")
    row.find("td").each ->
      iput=$(this).find("input.inline_edit")
      iput.width($(this).width())
      iput.height($(this).height())
      $(this).width($(this).width())
      $(this).height($(this).height())
      if iput.prop("hidden") != true
        iput.val($(this).find("span.dme_field_label").text())
    row.addClass("no_padding")
    row.find("td").find("input.inline_edit").each ->
      $(this).prop('disabled', false)
      if $(this).prop("hidden") != true
        $(this).show()
      row.find("span.dme_field_label").each ->
        $(this).hide()


$(document).ready ->
  $("a.field_cancel").on "click", ->
    restore_edit()

$(document).ready ->
  $("a.field_save").on "click", ->
    row = (($(this).parent("td")).parent("tr"))
    $.ajax
      url: "/dme_fields/" + row.attr("id")
      type: 'PUT'
      data: $("form").serialize()
      error: (xhr) ->
        row.replaceWith xhr.responseText
        restore_edit()
      success: (data) ->
        row.replaceWith data
        restore_edit()
      always: ->
        alert ($("form").serialize())
        restore_edit()


