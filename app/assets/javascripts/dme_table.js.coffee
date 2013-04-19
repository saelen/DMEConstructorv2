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
  $(".inline_edit input").each ->
    $(this).prop('disabled', true)
    $(this).hide()
  $(".inline_edit tr").each ->
    $(this).removeClass("info").removeClass("no_padding")
  $(".inline_edit a.field_edit").each ->
    $(this).hide()
  $(".inline_edit a.field_save").each ->
    $(this).hide()
  $(".inline_edit a.field_cancel").each ->
    $(this).hide()
  $(".inline_edit span.dme_field_label").each ->
    $(this).show()


restore_edit = () ->
  hide_all_edit_icons()
  $(".inline_edit a.field_edit").each ->
    $(this).show()
  $("#inline_add_record").removeClass("disabled")

$(document).ready ->
  restore_edit()

inline_save = (row) ->
  #Change posting and URLs to see if we are a new entry or modification of an existing
  url = 'dme_fields'
  type = 'PUT'
  if row.attr("id") == 'new'
    type = 'POST'
  else
    url += '/' + row.attr("id")

  $.ajax
    url: url
    type: type
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

set_edit = (row) ->
  $("#inline_add_record").addClass("disabled")
  hide_all_edit_icons()
  row.addClass("info")
  row.find("a.field_save").show()
  row.find("a.field_cancel").show()
  row.find("td").each ->
    iput=$(this).find("input.inline_edit")
    if iput.is(':text')
      iput.width($(this).width())
      iput.height($(this).height())
    $(this).width($(this).width())
    $(this).height($(this).height())
    if iput.prop("hidden") != true
      if iput.is(':text')
        iput.val($(this).find("span.dme_field_label").text())
  row.addClass("no_padding")
  row.find("td").find("input").each ->
    $(this).prop('disabled', false)
    $(this).show()
  row.find("span.dme_field_label").each ->
    $(this).hide()

$(document).on "click", ".inline_edit a.field_edit", (e) ->
  row = $(this).parent("td").parent("tr")
  set_edit(row)

$(document).on "click", ".inline_edit a.field_cancel", (e) ->
  row = $(this).parent("td").parent("tr")
  if row.attr("id") == 'new'
    row.remove()
  restore_edit()

$(document).on "click", ".inline_edit a.field_delete", (e)->
  row = $(this).parent("td").parent("tr")
  $.ajax
    url: "dme_fields/" + row.attr("id")
    type: 'DELETE'
    success: (data) ->
      row.remove()


$(document).on "click", ".inline_edit a.field_save", (e)->
  inline_save($(this).parent("td").parent("tr"))

$(document).on "keypress ", ".inline_edit input", (e)->
  if e.which == 13
    inline_save($(this).parent("td").parent("tr"))

fixHelper = (e, tr) ->
  $originals = tr.children()
  $helper = tr.clone()
  $helper.children().each (index) ->
    $(this).width $originals.eq(index).width()
  $helper

$(document).ready ->
  $("tbody.sortable").sortable(
    helper: fixHelper,
    cursor: 'move',
    stop: (event, ui) ->
      $.ajax
        url: "reorder"
        type: 'PUT'
        data: $(".sortable").sortable("serialize", { key: "sort[]", attribute: "data-sort" })
  )

$(document).ready ->
  $("#inline_add_record")
    .bind("ajax:before", ->
      if $("#inline_add_record").hasClass("disabled")
        return false
    )
    .bind("ajax:success", (xhr, data, status) ->
      $(".inline_edit > tbody:last").append(data)
      set_edit($(".inline_edit tr#new"))
    )

$(document).ready ->
  $(".combobox").combobox()

$(document).ready ->
  $(".resizeable").kendoGrid({
    batch:
    {}
    toolbar: ["create", "save", "cancel"],
    sortable: true,
    resizable: true,
    pageable: true,
    navigateable: true
  })