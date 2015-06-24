json.array! @infos do |info|
  json.array! [info.benutzer.nachname, info.datum_uhrzeit.strftime(FORMAT_INFO_DATUM), info.betreff, info.art, info.info_empfaengers[0].gelesen, info_path(info), info.id]
end
