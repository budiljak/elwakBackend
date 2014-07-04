# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

objekts = Objekt.create([{bezeichner:"Objekt 1"}, {bezeichner:"Objekt 2"}])
benutzers = Benutzer.create([{login:'admin', passwort:'1234', vorname:"Der große", nachname:"Admin", typ:VERWALTER}, {login:'kriecher', passwort:'1234', vorname:"Herbert", nachname:"Kriecher", typ:MITARBEITER, objekts:objekts}, {login:'huber', passwort:'12345', vorname:"Werner", nachname:"Huber", typ:MITARBEITER, objekts:[objekts.first]}, {login:'kunde', passwort:'123456', vorname:"Konrad", nachname:"Kunde", typ:KUNDE, objekts:[objekts.last]}])

infos = Info.create([
  {benutzer_id: benutzers[0].id, art: 3, datum_uhrzeit: DateTime.now, betreff:"Neue Datei für Objekt 1", text:"Für Objekt 1 gibt's eine neue Datei!", datei: "Objekt1\\Sonstiges\\objSonstiges2.pdf"},
  {benutzer_id: benutzers[0].id, art: 4, datum_uhrzeit: DateTime.now, betreff:"WICHTIG: Heute kommt der Chef!", text:"Der Chef kommt heute zu Besuch!"},
  {benutzer_id: benutzers[1].id, art: 1, datum_uhrzeit: DateTime.now, betreff:"Mittagessen", text:"Dies ist eine persönliche Nachricht!"},
  {benutzer_id: benutzers[1].id, art: 0, datum_uhrzeit: DateTime.now, betreff:"Irgendwas", text:"Irgendeine Nachricht"},
  {benutzer_id: benutzers[2].id, art: 2, datum_uhrzeit: DateTime.now, betreff:"Nagetiere im Objekt", text:"Im Objekt xyz sind Nagetiere aufgetaucht. Es wurden bereits Rattenfänger beauftragt."},
  {benutzer_id: benutzers[3].id, art: 2, datum_uhrzeit: DateTime.now, betreff:"Info VOM Kunden", text:"Hallo! Geht's meinem Objekt gut?"}
])
infos.each do |i| 
  benutzers.each do |b| 
    InfoEmpfaenger.create(info: i, benutzer:b, gelesen:false)
  end
end
