//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/

//= require jquery-ui/tabs
//= require jquery-ui/selectable
//= require jquery-ui/resizable
//= require jquery-ui/dialog

$(function() {
  if ($("#main_tabs").length) {
    $( "#main_tabs" ).tabs();
    refresh_infos_list();
    refresh_schichts_list();
    $( "#list_schichts").click(function () {
      refresh_rapports_list();
      refresh_checklistes_list();
    })
  }
});

function refresh_infos_list() {
  $.ajax({
    type: "GET", 
    url: "/infos.json",
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        var newRow = $("<tr><td>" + value[0] + "</td><td class=\"infos_datum\">" + value[1] + "</td><td>" + value[2] + "</td></tr>");
        if (value[3] != 0) {
          newRow.addClass("info_art_text_color_" + value[3]);
        }
        if (!value[4]) {
          newRow.addClass("info_ungelesen");
        }
        newRow.click(function () {
          showInfo(value[5]);
        });
        $( "#infos_list_body").append(newRow)
      })
      $( "#infos_list_body").selectable({filter: "tr"});
    }

  })
}

function showInfo(path) {
  $.ajax({
    type: "GET",
    url: path, 
    dataType: "html",
    success: function (data) {
      $('#info_container').html(data);
    }
  })
}

function refresh_schichts_list() {
  $( "#list_schichts").empty();
  $.ajax({
    type: "GET", 
    url: "/schichts.json",
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        var newEntry = $("<option value=\"" + value[1] + "\">" + value[0] + "</option>");
        $( "#list_schichts").append(newEntry)
      })
    }

  })
}

function refresh_rapports_list() {
  $( "#list_rapports").empty();
  var schicht_id = $( "#list_schichts").val();
  if (!schicht_id || schicht_id < 1) {
    return;
  }
  $.ajax({
    type: "GET", 
    url: "/rapports.json",
    data: {schicht_id: schicht_id},
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        var newEntry = $("<option value=\"" + value[1] + "\">" + value[0] + "</option>");
        $( "#list_rapports").append(newEntry)
      })
    }

  })
}

function refresh_checklistes_list() {
  $( "#list_checklistes").empty();
  var schicht_id = $( "#list_schichts").val();
  if (!schicht_id || schicht_id < 1) {
    return;
  }
  $.ajax({
    type: "GET", 
    url: "/checklistes.json",
    data: {schicht_id: schicht_id},
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        var newEntry = $("<option value=\"" + value[1] + "\">" + value[0] + "</option>");
        $( "#list_checklistes").append(newEntry)
      })
    }

  })
}

function not_yet() {
//  $("<div><p>Diese Funktion ist noch nicht umgesetzt!</p></div>").dialog({
//    title: "KDS-Net",
//    modal: true,
//    buttons: {
//      Ok: function() {
//        $( this ).dialog( "close" );
//      }
//    }
//  });
  alert("Diese Funktion ist noch nicht umgesetzt!");
}
