json.array!(@schichts) do |schicht|
  json.array! [schicht_bezeichner(schicht), schicht.id, 
    (current_schicht && schicht.id == current_schicht.id) ? (edit_wachbuch_eintrag_path(schicht.wachbuch_eintrag, format: :html)) : (wachbuch_eintrag_path(schicht.wachbuch_eintrag, format: :html))]
end
