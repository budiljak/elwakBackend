xml.instruct!
xml.infos do
  @infos.each do |i|
    xml.info do
      xml.id i.id
      xml.benutzer_id i.benutzer_id
      xml.art i.art
      xml.datum_uhrzeit i.datum_uhrzeit.strftime("%F %H:%M")
      xml.betreff i.betreff
      xml.text i.text
      xml.datei i.datei
      #xml.info_empfaengers do
        #i.info_empfaengers.each do |ie|
          #xml.info_empfaenger do
            #xml.id ie.id
            #xml.info_id ie.info_id
            #xml.benutzer_id ie.benutzer_id
            #xml.gelesen ie.gelesen
          #end
        #end
      #end
    end
  end
end


