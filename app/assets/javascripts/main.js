//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.

//= require jquery-ui/tabs
//= require jquery-ui/selectable
//= require jquery-ui/resizable
//= require jquery-ui/dialog
//= require jquery-ui/datepicker
//= require jquery-ui/datepicker-de

var idleTime = 0;
var lastInfoId = "-1";

$(function() {
  $(document).ajaxStart(function() {$("body").addClass("loading"); });
  $(document).ajaxStop(function() {$("body").removeClass("loading"); });
  if ($("#main_tabs").length) {
    init_main();
  } else if ($(".login_box").length) {
    $(".login_box input, .login_box select").keypress(function (e) {
      if (e.which == 13) {
        $('.login_box form').submit();
        return false;    //<---- Add this line
      }
    });
  }
});

function init_main() {
  $( "#main_tabs" ).tabs();
  $("#infos_list_body").selectable({
    filter: "tr",
    autoRefresh: false,
    stop: function() {
      var selected = $("#infos_list_body .ui-selected");
      if (selected) {
        showInfo(selected.data("info-url"), selected.hasClass('info_ungelesen'));
      }
      var icon = $("#newInfoIcon");
      if (icon.css('display') != 'none') {
        icon.css('display', 'none');
      }
    }
  });
  $( "#list_schichts").click(function () {
    schicht_selected();
  });
  $("#list_schichts").dblclick(function () {
    open_wachbuch_eintrag();
  });
  $( "#list_rapports").click(function () {
    rapport_selected();
  });
  $("#list_rapports").dblclick(function () {
    open_rapport();
  });
  $( "#list_checklistes").click(function () {
    checkliste_selected();
  });
  $("#list_checklistes").dblclick(function () {
    open_checkliste();
  });
  $("input[name=pdf_datei_art]").click(function () {
    refresh_pdf_dateis_list();
  });
  $("#pdf_dateis_list").click(function() {
    pdf_datei_selected();
  });
  init_dokument_typ_selector();
  refresh_all_lists();
  initIdleTimer();
  get_after_login_actions();
}

function get_after_login_actions() {
  $.ajax({
    type: "GET",
    url: '/main/after_login.js', 
    dataType: "script"
  });
}

function get_before_logout_actions() {
  $.ajax({
    type: "GET",
    url: '/main/before_logout.js', 
    dataType: "script"
  });
}

function initIdleTimer() {
  //Increment the idle time counter every minute.
  var idleInterval = setInterval(timerIncrement, 60000); // 1 minute

  //Zero the idle timer on mouse movement.
  $(this).mousemove(function (e) {
    idleTime = 0;
  });
  $(this).keypress(function (e) {
    idleTime = 0;
  });
}

function timerIncrement() {
  idleTime = idleTime + 1;
  if (idleTime >= 2) { // every 2 minutes
    idleTime = 0;
    refresh_all_lists();
  }
}

function refresh_all_lists() {
  refresh_infos_list();
  refresh_current_schicht();
  refresh_schichts_list();
  var selectedPdf = $("#pdf_dateis_list option:selected");
  var callback;
  if (selectedPdf) {
    callback = function() {
      var name = selectedPdf.text().toString();
      searchPdfDatei(name);
    }
  }
  refresh_pdf_dateis_list(callback);
}

function refresh_infos_list(callback) {
  var currentSelection = $("#infos_list_body .ui-selected");
  var selected_info_id = "";
  if (currentSelection.length) {
    selected_info_id = currentSelection.data("info-id").toString(); // 'toString' notwending, weil sonst nur eine Referenz auf die Eigenschaft des Objekts (tr) erstellt wird. 
  }
  $.ajax({
    type: "GET", 
    url: "/infos.json",
    dataType: "json",
    success: function (data) {
      var listBody = $( "#infos_list_body");
      listBody.empty();
      $.each(data, function (index, value) {
        var newRow = $("<tr><td>" + value[0] + "</td><td class=\"infos_datum\">" + value[1] + "</td><td>" + value[2] + "</td></tr>");
        if (value[3] != 0) {
          newRow.addClass("info_art_text_color_" + value[3]);
        }
        if (!value[4]) {
          newRow.addClass("info_ungelesen");
        }
        newRow.data("info-url", value[5]);
        if (selected_info_id.length > 0 && selected_info_id == value[6]) {
          newRow.addClass("ui-selected");
        }
        newRow.data("info-id", value[6]);
        listBody.append(newRow)
      });
      listBody.selectable("refresh");
      if (data.length) {
        refreshNewInfoIcon(data[0][6], data[0][4]);
      }
      if (callback) {
        callback();
      }
    }
  });
}

function refreshNewInfoIcon(infoId, isRead) {
  if (!isRead && infoId != lastInfoId) {
    lastInfoId = infoId;
    var icon = $("#newInfoIcon");
    if (icon.css('display') == 'none') {
      icon.css('display', 'inline')
    }
  }
}

function showInfobox() {
  $( "#main_tabs" ).tabs( "option", "active", 0 );
}

function showInfo(path, unread) {
  $.ajax({
    type: "GET",
    url: path, 
    dataType: "html",
    success: function (data) {
      $('#info_container').html(data);
      if (unread) {
        refresh_infos_list();
      }
    }
  })
}

function readDocument(name, art, markReadPath) {
  if (!markReadPath || markReadPath.length < 1) {
    showDocument(name, art);
  } else {
    $.ajax({
      type: "GET",
      url: markReadPath, 
      dataType: "script",
      complete: function() {
        showDocument(name, art);
        refresh_infos_list(function () {
         var url = $("#infos_list_body .ui-selected").data('info-url');
         showInfo(url, false)
        });
      }
    });
  }
}
    
function showDocument(name, art) {
  $( "#main_tabs" ).tabs( "option", "active", 2 );
  var callback = function() {
    searchPdfDatei(name);
  };
  var radio_art = $( "input[name=pdf_datei_art][value=" + art + "]");
  if (!radio_art.prop('checked')) {
    radio_art.prop('checked', true);
    refresh_pdf_dateis_list(callback);
  } else {
    callback();
  }
}
  
function open_new_info() {
  $(" <div id=\"new_info_dialog\" />").dialog({
    title: 'Neue Nachricht',
    closeText: 'Schließen',
    autoOpen: true, 
    modal: true,
    resizable: false,
    width: 750,
    height: 650,
  open: function() {
    $("#new_info_dialog").load('/infos/new.html');
  }, 
  close: function( event, ui ) {
    close_new_info();
  }
  });
}

function close_new_info() {
  $("#new_info_dialog").dialog("destroy");
}


function start_new_schicht() {
  $(" <div id=\"new_schicht_dialog\" />").dialog({
    title: 'Schicht beginnen',
    closeText: 'Schließen',
    autoOpen: true, 
    modal: true,
    resizable: false,
    width: 270,
    height: 350,
    open: function() {
      $("#new_schicht_dialog").load('/schichts/new.html');
    }, 
    close: function( event, ui ) {
      close_new_schicht();
    }
  });
}

function close_new_schicht() {
  $("#new_schicht_dialog").dialog("destroy");
}

function finish_schicht() {
  if (!confirm("Wollen Sie die laufende Schicht beenden?")) {
    return;
  }
  $.ajax({
    type: "GET",
    url: '/finish_schicht.js', 
    dataType: "script"
  });
}
  

function refresh_current_schicht() {
  $.ajax({
    type: "GET",
    url: "/schichts/current.json", 
    dataType: "json",
    success: function (data) {
      $('#btn_schicht').off("click");
      if (!data.length) {
        $('#btn_schicht').html('Schicht beginnen');
        $('#btn_schicht').click(function() {
          start_new_schicht();
        });
        $('#current_schicht').html('&nbsp;');
      } else {
        $('#btn_schicht').html('Schicht beenden');
        $('#btn_schicht').click(function() {
          finish_schicht();
        });
        $('#current_schicht').html(data[0]);
      }
    }
  });
}
  

function refresh_schichts_list() {
  var schichtsList = $( "#list_schichts");
  var selectedId = schichtsList.val();
  schichtsList.empty();
  $.ajax({
    type: "GET", 
    url: "/schichts.json",
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        var newEntry = $("<option value=\"" + value[1] + "\">" + value[0] + "</option>");
        newEntry.data("wb-path", value[2]);
        if (value[2].indexOf("edit") >= 0) {
          newEntry.addClass('current-schicht');
        }
        if (selectedId && value[1] == selectedId) {
          newEntry.prop("selected", true);
        }
        schichtsList.append(newEntry)
      });
      if (!selectedId && schichtsList.children().length != 0) {
        schichtsList[0].selectedIndex = 0;
      }
      schicht_selected();
    }

  })
}

function schicht_selected() {
  refresh_rapports_list();
  refresh_checklistes_list();
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
      var rapportsList = $( "#list_rapports");
      $.each(data, function (index, value) {
        var newEntry = $("<option value=\"" + value[1] + "\">" + value[0] + "</option>");
        newEntry.data("delete-path",  value[2]);
        rapportsList.append(newEntry);
      });
      if (rapportsList.children().length != 0) {
        rapportsList[0].selectedIndex = 0;
        rapport_selected();
      }
    }
  });
}

function rapport_selected() {
  var selected = $("#list_rapports option:selected");
  $("#btn_delete_rapport").attr('disabled', (selected.data("delete-path").length == 0));
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
      var checklistesList = $( "#list_checklistes");
      $.each(data, function (index, value) {
        var newEntry = $("<option value=\"" + value[1] + "\">" + value[0] + "</option>");
        newEntry.data("delete-path",  value[2]);
        checklistesList.append(newEntry);
      });
      if (checklistesList.children().length != 0) {
        checklistesList[0].selectedIndex = 0;
        checkliste_selected();
      }
    }

  })
}

function checkliste_selected() {
  var selected = $("#list_checklistes option:selected");
  $("#btn_delete_checkliste").attr('disabled', (selected.data("delete-path").length == 0));
}

function refresh_pdf_dateis_list(callback) {
  $( "#pdf_dateis_list").empty();
  var pdf_datei_art = $( "input[name=pdf_datei_art]:checked").val();
  if (!pdf_datei_art || !pdf_datei_art.length) {
    return;
  }
  $.ajax({
    type: "GET", 
    url: "/pdf_dateis.json",
    data: {art: pdf_datei_art},
    dataType: "json",
    success: function (data) {
      var pdfDateisList = $( "#pdf_dateis_list");
      $.each(data, function (index, value) {
        var newEntry = $("<option value=\"" + value[1] + "\">" + value[0] + "</option>");
        pdfDateisList.append(newEntry);
      });
      if (pdfDateisList.children().length != 0) {
        pdfDateisList[0].selectedIndex = 0;
      }
      pdf_datei_selected();
      if (callback) {
        callback();
      }
    }
  });
}

function searchPdfDatei(name) {
  $( "#pdf_dateis_list option").each(function(index) {
    var opt = $(this);
    if (opt.text() == name) {
      opt.prop("selected", true);
      pdf_datei_selected();
      return false;
    }
  });
}

function pdf_datei_selected() {
  var path = $("#pdf_dateis_list option:selected").val();
  var pdfCont = $("#pdf_datei_viewer_container");
  if (path && path.length) {
    var objTag = $("object", pdfCont);
    if (objTag.length && objTag.attr("data") == path) {
      return;
    }
    var embeddedPdf = $("<object><p>Eingebettete PDF-Anzeige wird nicht unterstützt. Sie können die Datei <a href=\"" + path + "\" target=\"_blank\">hier</a> herunterladen. </p></object>");
    embeddedPdf.attr("data", path);
    embeddedPdf.attr("type", "application/pdf");
    embeddedPdf.attr("width", "100%");
    embeddedPdf.attr("height", "100%");
    pdfCont.html(embeddedPdf);
  } else {
    pdfCont.html("Bitte wählen Sie ein Dokument!");
  }
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

function open_rapport() {
  var url = $("#list_rapports").val();
  if (!url) {
    alert("Bitte erst einen Rapport wählen!");
    return;
  }
  $(" <div id=\"rapport_dialog\" />").dialog({
    title: 'Rapport',
    closeText: 'Schließen',
    autoOpen: true, 
    modal: true,
    resizable: false,
    width: 600,
    height: 650,
  open: function() {
    $("#rapport_dialog").load(url);
  }, 
  close: function( event, ui ) {
    close_rapport();
  }
  });
}

function close_rapport() {
  $("#rapport_dialog").dialog("destroy");
}

function print_rapports(rapport_id) {
  if (!rapport_id) {
    var schicht_id = $( "#list_schichts").val();
    if (!schicht_id || schicht_id < 1) {
      alert("Bitte erst eine Schicht wählen!");
      return;
    }
    url = '/rapports/print.js?schicht_id=' + schicht_id
  } else {
    url = '/rapports/print.js?rapport_id=' + rapport_id
  }

  $.ajax({
    type: "GET", 
    url: url,
    dataType: "script"
  });
}

function delete_rapport() {
  var selected = $("#list_rapports option:selected");
  if (!selected.length) {
    alert("Bitte erst einen Rapport wählen!");
    return;
  }
  var url = selected.data('delete-path');
  if (!confirm("Wollen Sie diesen Rapport löschen?")) {
    return;
  }
  $.ajax({
    type: "DELETE", 
    url: url,
    dataType: "script"
  });
}

function open_wachbuch_eintrag() {
  var selected = $("#list_schichts").find('option:selected');
  if (!selected.length) {
    alert("Bitte erst eine Schicht wählen!");
    return;
  }
  var url = selected.data('wb-path');
  $(" <div id=\"wachbuch_eintrag_dialog\" />").dialog({
    title: 'Wachbuch-Eintrag',
    closeText: 'Schließen',
    autoOpen: true, 
    modal: true,
    resizable: false,
    width: 900,
    height: 600,
  open: function() {
    $("#wachbuch_eintrag_dialog").load(url);
  }, 
  close: function( event, ui ) {
    close_wachbuch_eintrag();
  }
  });
}

function close_wachbuch_eintrag() {
  $("#wachbuch_eintrag_dialog").dialog("destroy");
}

function open_choose_vorlage(url) {
  $(" <div id=\"choose_vorlage_dialog\" />").dialog({
    title: 'Vorlage wählen',
  closeText: 'Schließen',
  autoOpen: true, 
  modal: true,
  resizable: false,
  width: 400,
  height: 400,
  open: function() {
    $("#choose_vorlage_dialog").load(url);
  }, 
  close: function( event, ui ) {
    close_choose_vorlage();
  }
  });
}

function choose_vorlage(vorlage_id) {
  if (!vorlage_id) {
    alert("Bitte Vorlage wählen!");
  } else {
    close_choose_vorlage();
    open_checkliste(vorlage_id);
  }
}

function close_choose_vorlage() {
  $("#choose_vorlage_dialog").dialog("destroy");
}
  
function open_checkliste(vorlage_id) {
  var url = $("#list_checklistes").val();

  if (vorlage_id) {
    url += "?vorlage_id=" + vorlage_id
  }

  if (!url) {
    alert("Bitte erst einen Checkliste wählen!");
    return;
  } else if (url.indexOf("new") >= 0 && !vorlage_id) {
    open_choose_vorlage(url);
    return;
  }

  $(" <div id=\"checkliste_dialog\" />").dialog({
    title: 'Checkliste',
    closeText: 'Schließen',
    autoOpen: true, 
    modal: true,
    resizable: false,
    width: 800,
    height: 600,
  open: function() {
    $("#checkliste_dialog").load(url);
  }, 
  close: function( event, ui ) {
    close_checkliste();
  }
  });
}

function close_checkliste() {
  $("#checkliste_dialog").dialog("destroy");
}

function delete_checkliste() {
  var selected = $("#list_checklistes option:selected");
  if (!selected.length) {
    alert("Bitte erst einen Checkliste wählen!");
    return;
  }
  var url = selected.data('delete-path');
  if (!confirm("Wollen Sie diesen Checkliste löschen?")) {
    return;
  }
  $.ajax({
    type: "DELETE", 
    url: url,
    dataType: "script"
  });
}

function open_change_password() {
  $(" <div id=\"change_password_dialog\" />").dialog({
    title: 'Passwort ändern',
    closeText: 'Schließen',
    autoOpen: true, 
    modal: true,
    resizable: false,
    width: 300,
    height: 350,
  open: function() {
    $("#change_password_dialog").load('/benutzers/change_password_dialog.html');
  }, 
  close: function( event, ui ) {
    close_change_password();
  }
  });
}

function close_change_password() {
  $("#change_password_dialog").dialog("destroy");
}

function init_ja_nein_frames() {
  var frames = $(".ja_nein_frame");
  frames.click(function () {
    ja_nein_frame_click(this);
  });

  frames.each(function() {
    ja_nein_frame_click(this);
  });
}

function ja_nein_frame_click(frame) {
  var val = $(frame).find(":checked").val();
  if (val == "true" || val == "ja") {
    $(frame).addClass("ja");
    $(frame).removeClass("nein");
  } else if (val == "false" || val == "nein") {
    $(frame).addClass("nein");
    $(frame).removeClass("ja");
  } else {
    $(frame).removeClass("ja");
    $(frame).removeClass("nein");
  }
}

function init_time_date_inputs() {
  $("input.date_input").each(function(index) {
    var el = $(this)
    if (el.attr("readonly") != "readonly") {
      el.datepicker($.datepicker.regional['de']);
    }
  });
  //$("input.time_input").mask("00:00");
}

function init_dokument_typ_selector() {
  $(".toggle-btn input[type=radio]").addClass("visuallyhidden");
  $(".toggle-btn input[type=radio]").change(function() {
    if( $(this).attr("name") ) {
      $(this).parent().addClass("success").siblings().removeClass("success")
    } else {
      $(this).parent().toggleClass("success");
    }
  });
}

