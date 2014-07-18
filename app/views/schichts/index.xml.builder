xml.instruct!
xml.schichts do
  @schichts.each do |s|
    xml.schicht do
      xml.id s.id
      xml.objekt_id s.objekt_id
      xml.benutzer_id s.benutzer_id
      xml.datum s.datum.strftime("%F")
      xml.uhrzeit_beginn s.uhrzeit_beginn
      xml.uhrzeit_ende s.uhrzeit_ende
      xml.rapports do
        s.rapports.each do |r|
          xml.rapport do
            xml.beschreibung r.beschreibung
            xml.ort r.ort
            xml.uhrzeit r.uhrzeit
            xml.massnahmen r.massnahmen
            xml.position r.position
          end
        end
      end
      xml.wachbuch_eintrag do
        xml.besonderheiten s.wachbuch_eintrag.besonderheiten
        xml.schaeden s.wachbuch_eintrag.schaeden
        xml.ausruestung_vollzaehlig s.wachbuch_eintrag.ausruestung_vollzaehlig
        xml.ausruestung_funktion s.wachbuch_eintrag.ausruestung_funktion
        xml.schluessel_vollzaehlig s.wachbuch_eintrag.schluessel_vollzaehlig
        xml.schluessel_bemerkung s.wachbuch_eintrag.schluessel_bemerkung
        xml.kontrollanrufs do
          s.wachbuch_eintrag.kontrollanrufs.each do |ka|
            xml.kontrollanruf do
              xml.uhrzeit ka.uhrzeit
              xml.objekt ka.objekt
              xml.bemerkung ka.bemerkung
              xml.position ka.position
            end
          end
        end
        xml.kontrollgangs do
          s.wachbuch_eintrag.kontrollgangs.each do |kg|
            xml.kontrollgang do
              xml.uhrzeit kg.uhrzeit
              xml.bemerkung kg.bemerkung
              xml.position kg.position
            end
          end
        end
      end
      xml.checklistes do
        s.checklistes.each do |c|
          xml.checkliste do
            xml.checklisten_vorlage_id c.checklisten_vorlage_id
            xml.uhrzeit c.uhrzeit
            xml.position c.position
            xml.checklisten_werts do
              c.checklisten_werts.each do |cw|
                xml.checklisten_wert do
                  xml.checklisten_eintrag_id cw.checklisten_eintrag_id
                  xml.inhalt cw.inhalt
                end
              end
            end
          end
        end
      end
    end
  end
end
