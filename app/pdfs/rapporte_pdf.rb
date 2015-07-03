class RapportePdf < Prawn::Document
  
  def initialize(rapporte)
    super()
    @rapporte = rapporte
    if @rapporte.length > 1
      make_header("Rapporte")
    else
      make_header("Rapport")
    end
    schicht_header
    move_down 35
    make_rapports
  end
  
  def make_header(content)
    stroke_horizontal_rule
    move_down 15
    pad_bottom(10) {text content}
    stroke_horizontal_rule
    move_down 15
  end
  
  def schicht_header
    s = @rapporte[0].schicht
    table_data = [['Objekt: ', s.objekt.bezeichner, 'Wachmann: ', s.benutzer.nachname_vorname_kurz], ['Datum: ', s.datum.strftime(FORMAT_SCHICHT_DATUM), 'Schichtzeit: ', s.schichtzeit]]

    table table_data, column_widths: [80, 180, 100, 180], cell_style: {borders: []}
  end

  def make_rapports
    @rapporte.each do |r|
      make_header("Uhrzeit: " + r.uhrzeit)
      text "Vorkommnis: "
      text r.beschreibung
      move_down 15
      text "Wo: " 
      text r.ort
      move_down 15
      text "Maßnahmen: "
      text r.massnahmen
      move_down 20
    end
  end
  
  
end
