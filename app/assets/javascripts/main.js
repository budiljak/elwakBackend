//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.

//= require jquery-ui/tabs
//= require jquery-ui/selectable
//= require jquery-ui/resizable
//= require jquery-ui/dialog
//= require jquery-ui/datepicker
//= require jquery-ui/datepicker-de


$(function() {
  $(document).ajaxStart(function() {$("body").addClass("loading"); });
  $(document).ajaxStop(function() {$("body").removeClass("loading"); });
  if ($("#main_tabs").length) {
    $( "#main_tabs" ).tabs();
    refresh_infos_list();
    refresh_current_schicht();
    refresh_schichts_list();
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
  }
});

function refresh_infos_list() {
  $.ajax({
    type: "GET", 
    url: "/infos.json",
    dataType: "json",
    success: function (data) {
      $( "#infos_list_body").empty();
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

function start_new_schicht() {
  $(" <div id=\"new_schicht_dialog\" />").dialog({
    title: 'Schicht beginnen',
    closeText: 'Schließen',
    autoOpen: true, 
    modal: true,
    resizable: false,
    width: 600,
    height: 600,
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
  $( "#list_schichts").empty();
  $.ajax({
    type: "GET", 
    url: "/schichts.json",
    dataType: "json",
    success: function (data) {
      var schichtsList = $( "#list_schichts");
      $.each(data, function (index, value) {
        var newEntry = $("<option value=\"" + value[1] + "\">" + value[0] + "</option>");
        newEntry.data("wb-path", value[2]);
        if (value[2].contains("edit")) {
          newEntry.css('font-weight', 'bold');
        }
        schichtsList.append(newEntry)
      });
      if (schichtsList.children().length != 0) {
        schichtsList[0].selectedIndex = 0;
        schicht_selected();
      }
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

  })
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
  } else if (url.contains("new") && !vorlage_id) {
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

