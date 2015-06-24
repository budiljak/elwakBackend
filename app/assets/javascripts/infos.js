
function init_new_info_dialog() {
  $("#recipient_benutzers").MultiSelect({css_class_selected: 'selectedOptionMultiSelect'});
  $("#recipient_objekts").MultiSelect({css_class_selected: 'selectedOptionMultiSelect'});
}

function open_choose_document(url) {
  $(" <div id=\"choose_document_dialog\" />").dialog({
    title: 'Dokument wählen',
  closeText: 'Schließen',
  autoOpen: true, 
  modal: true,
  resizable: false,
  width: 400,
  height: 400,
  open: function() {
    $("#choose_document_dialog").load(url);
  }, 
  close: function( event, ui ) {
    close_choose_document();
  }
  });
}

function close_choose_document() {
  $("#choose_document_dialog").dialog("destroy");
}

function apply_document() {
  var value = $("#choose_document_list").val();
  var text = $("#choose_document_list option:selected").text();

  $("#info_datei").val(value);
  $("#datei_name").val(text);

  close_choose_document();
}
