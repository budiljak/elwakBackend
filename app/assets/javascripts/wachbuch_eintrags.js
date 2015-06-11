function init_wb_dialog() {
  refresh_kontrollanrufs_list();
  refresh_kontrollgangs_list();
  init_ja_nein_frames();
  $('#kontrollanruf_neu').click(function () {
    open_kontrollanruf('/kontrollanrufs/new.html?wachbuch_eintrag_id=' + wachbuch_eintrag_id);
  });
  $('#kontrollanruf_anzeigen').click(function () {
    open_kontrollanruf();
  });
  $('#kontrollanruf_loeschen').click(function () {
    not_yet();
  });
  $('#kontrollgang_neu').click(function () {
    open_kontrollgang('/kontrollgangs/new.html?wachbuch_eintrag_id=' + wachbuch_eintrag_id);
  });
  $('#kontrollgang_anzeigen').click(function () {
    open_kontrollgang();
  });
  $('#kontrollgang_loeschen').click(function () {
    not_yet();
  });
}

function refresh_kontrollanrufs_list() {
  $.ajax({
    type: "GET", 
    url: "/kontrollanrufs.json?wb_id=" + wachbuch_eintrag_id,
    dataType: "json",
    success: function (data) {
      $( "#kontrollanrufs_list_body").empty();
      $.each(data, function (index, value) {
        var newRow = $("<tr><td>" + value[0] + "</td><td>" + value[1] + "</td></tr>");
        newRow.data('url', value[2]);
        newRow.dblclick(function () {
          open_kontrollanruf();
        });
        $( "#kontrollanrufs_list_body").append(newRow)
      })
      $( "#kontrollanrufs_list_body").selectable({filter: "tr"});
    }
  });
}

function open_kontrollanruf(url) {
  if (!url) {
    var selected = $("#kontrollanrufs_list_body .ui-selected");
    if (!selected.length) {
      alert("Bitte erst einen Kontrollanruf wählen!");
      return;
    }
    url = selected.data('url');
  }
  $(" <div id=\"kontrollanruf_dialog\" />").dialog({
    title: 'Kontrollanruf',
    closeText: 'Schließen',
    autoOpen: true, 
    modal: true,
    resizable: false,
    width: 400,
    height: 400,
  open: function() {
    $("#kontrollanruf_dialog").load(url);
  }, 
  close: function( event, ui ) {
    close_kontrollanruf();
  }
  });
}

function close_kontrollanruf() {
  $("#kontrollanruf_dialog").dialog("destroy");
}

function refresh_kontrollgangs_list() {
  $.ajax({
    type: "GET", 
    url: "/kontrollgangs.json?wb_id=" + wachbuch_eintrag_id,
    dataType: "json",
    success: function (data) {
      $( "#kontrollgangs_list_body").empty();
      $.each(data, function (index, value) {
        var newRow = $("<tr><td>" + value[0] + "</td><td>" + value[1] + "</td></tr>");
        newRow.data('url', value[2]);
        newRow.dblclick(function () {
          open_kontrollgang();
        });
        $( "#kontrollgangs_list_body").append(newRow)
      })
      $( "#kontrollgangs_list_body").selectable({filter: "tr"});
    }
  });
}

function open_kontrollgang(url) {
  if (!url) {
    var selected = $("#kontrollgangs_list_body .ui-selected");
    if (!selected.length) {
      alert("Bitte erst einen Kontrollgang wählen!");
      return;
    }
    url = selected.data('url');
  }
  $(" <div id=\"kontrollgang_dialog\" />").dialog({
    title: 'Kontrollgang',
    closeText: 'Schließen',
    autoOpen: true, 
    modal: true,
    resizable: false,
    width: 400,
    height: 400,
  open: function() {
    $("#kontrollgang_dialog").load(url);
  }, 
  close: function( event, ui ) {
    close_kontrollgang();
  }
  });
}

function close_kontrollgang() {
  $("#kontrollgang_dialog").dialog("destroy");
}

