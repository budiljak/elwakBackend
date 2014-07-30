# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'date'
require 'time'

objekts = Objekt.create([{bezeichner:"Objekt 1"}, {bezeichner:"Objekt 2"}])
benutzers = Benutzer.create([{login:'admin', passwort:'1234', vorname:"Der große", nachname:"Admin", typ:VERWALTER}, {login:'kriecher', passwort:'1234', vorname:"Herbert", nachname:"Kriecher", typ:MITARBEITER, objekts:objekts}, {login:'huber', passwort:'12345', vorname:"Werner", nachname:"Huber", typ:MITARBEITER, objekts:[objekts.first]}, {login:'kunde', passwort:'123456', vorname:"Konrad", nachname:"Kunde", typ:KUNDE, objekts:[objekts.last]}])

tag = DateTime.new(1.year.ago.year, 1.year.ago.month, 1.year.ago.day)
while tag < DateTime.now do
  puts "tag: " + tag.to_s
  infos = Info.create([
    {benutzer_id: benutzers[0].id, art: 3, datum_uhrzeit: tag + 1.hours, betreff:"Neue Datei für Objekt 1", text:"Für Objekt 1 gibt's eine neue Datei!", datei: "Objekt1\\Sonstiges\\objSonstiges2.pdf"},
    {benutzer_id: benutzers[0].id, art: 4, datum_uhrzeit: tag + 4.hours, betreff:"WICHTIG: Heute kommt der Chef!", text:"Der Chef kommt heute zu Besuch!"},
    {benutzer_id: benutzers[1].id, art: 1, datum_uhrzeit: tag + 13.hours, betreff:"Mittagessen", text:"Dies ist eine persönliche Nachricht!"},
    {benutzer_id: benutzers[1].id, art: 0, datum_uhrzeit: tag + 15.hours, betreff:"Irgendwas", text:"Irgendeine Nachricht"},
    {benutzer_id: benutzers[2].id, art: 2, datum_uhrzeit: tag + 20.hours, betreff:"Nagetiere im Objekt", text:"Im Objekt xyz sind Nagetiere aufgetaucht. Es wurden bereits Rattenfänger beauftragt."},
    {benutzer_id: benutzers[3].id, art: 2, datum_uhrzeit: tag + 22.hours, betreff:"Info VOM Kunden", text:"Hallo! Geht's meinem Objekt gut?"}
  ])
  infos.each do |i| 
    benutzers.each do |b| 
      InfoEmpfaenger.create(info: i, benutzer:b, gelesen:false)
    end
  end
  schichts = Schicht.create([
    {objekt: objekts[0], benutzer: benutzers[1], datum: tag, uhrzeit_beginn: (tag + 2.hours).strftime("%F"), uhrzeit_ende: tag + 10.hours}, 
    {objekt: objekts[0], benutzer: benutzers[2], datum: tag, uhrzeit_beginn: (tag + 10.hours).strftime("%F"), uhrzeit_ende: tag + 18.hours}, 
    {objekt: objekts[0], benutzer: benutzers[1], datum: tag, uhrzeit_beginn: (tag + 18.hours).strftime("%F"), uhrzeit_ende: tag + 26.hours}
  ])
  schichts.each do |s|
    zeitBeginn = Time.parse(s.uhrzeit_beginn)
    Rapport.create([
      {schicht: s, beschreibung: 'beschr1', ort:'ort1', uhrzeit: (zeitBeginn + 2.hours).strftime("%F"), massnahmen: 'massn1', position: 1}, 
      {schicht: s, beschreibung: 'beschr2', ort:'ort2', uhrzeit: (zeitBeginn + 4.hours).strftime("%F"), massnahmen: 'massn2', position: 2}, 
      {schicht: s, beschreibung: 'beschr3', ort:'ort3', uhrzeit: (zeitBeginn + 6.hours).strftime("%F"), massnahmen: 'massn3', position: 3}
    ])
    wb = WachbuchEintrag.create({schicht: s, besonderheiten: 'bes', schaeden: 'schä', schluessel_bemerkung: 'schlüBem'})
    Kontrollanruf.create({wachbuch_eintrag: wb, uhrzeit: zeitBeginn + 2.hours, bemerkung: 'bem', objekt: 'obj'})
    Kontrollgang.create({wachbuch_eintrag: wb, uhrzeit: zeitBeginn + 4.hours, bemerkung: 'bem'})
  end
  tag = tag + 1.days
end
