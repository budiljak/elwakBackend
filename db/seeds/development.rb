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

checklisten_vorlages = ChecklistenVorlage.create([
  {bezeichner: "liste1", objekt: objekts[0]},
  {bezeichner: "liste2", objekt: objekts[0]}
])
ChecklistenEintrag.create([
  {checklisten_vorlage: checklisten_vorlages[0], bezeichner: "eintrag1", was: "was1", wann: "wann1", typ: CHECKLISTE_TYP_JA_NEIN, position: 1},
  {checklisten_vorlage: checklisten_vorlages[0], bezeichner: "eintrag2", was: "was2", wann: "wann2", typ: CHECKLISTE_TYP_DATUM, position: 2},
  {checklisten_vorlage: checklisten_vorlages[0], bezeichner: "eintrag3", was: "was3", wann: "wann3", typ: CHECKLISTE_TYP_UHRZEIT, position: 3},
  {checklisten_vorlage: checklisten_vorlages[0], bezeichner: "eintrag4", was: "was4", wann: "wann4", typ: CHECKLISTE_TYP_FREITEXT, position: 4},
  {checklisten_vorlage: checklisten_vorlages[1], bezeichner: "eintrag_test1", was: "was_test1", wann: "wann_test1", typ: CHECKLISTE_TYP_JA_NEIN, position: 1},
  {checklisten_vorlage: checklisten_vorlages[1], bezeichner: "eintrag_test2", was: "was_test2", wann: "wann_test2 mit ein bisschen mehr text zum testen... und einem laaaaaaaaaaaaaaaaaaaaaaaaaaaaaannnnnnnnnnnnnnnnggggggggggggggeeeemmmmmmm Wort", typ: CHECKLISTE_TYP_DATUM, position: 2}
]) 

PdfDatei.create([
  {art: 1, name: "AllgArbeitsanw1.pdf", datei: File.open(File.join(Rails.root, "db/seeds/testPdfs/arbAllg/AllgArbeitsanw1.pdf"))},
  {art: 1, name: "AllgArbeitsanw2.pdf", datei: File.open(File.join(Rails.root, "db/seeds/testPdfs/arbAllg/AllgArbeitsanw2.pdf"))},
  {art: 1, name: "AllgArbeitsanw3.pdf", datei: File.open(File.join(Rails.root, "db/seeds/testPdfs/arbAllg/AllgArbeitsanw3.pdf"))}
])

objekts.each do |o|
  PdfDatei.create([
    {objekt_id: o.id, art: 2, name: "ObjArbeitsanw1.pdf", datei: File.open(File.join(Rails.root, "db/seeds/testPdfs/arbObj/ObjArbeitsanw1.pdf"))},
    {objekt_id: o.id, art: 2, name: "ObjArbeitsanw2.pdf", datei: File.open(File.join(Rails.root, "db/seeds/testPdfs/arbObj/ObjArbeitsanw2.pdf"))},
    {objekt_id: o.id, art: 2, name: "ObjArbeitsanw3.pdf", datei: File.open(File.join(Rails.root, "db/seeds/testPdfs/arbObj/ObjArbeitsanw3.pdf"))},
    {objekt_id: o.id, art: 3, name: "ObjSonstiges1.pdf", datei: File.open(File.join(Rails.root, "db/seeds/testPdfs/sonstObj/ObjSonstiges1.pdf"))},
    {objekt_id: o.id, art: 3, name: "ObjSonstiges2.pdf", datei: File.open(File.join(Rails.root, "db/seeds/testPdfs/sonstObj/ObjSonstiges2.pdf"))},
    {objekt_id: o.id, art: 3, name: "ObjSonstiges3.pdf", datei: File.open(File.join(Rails.root, "db/seeds/testPdfs/sonstObj/ObjSonstiges3.pdf"))}
  ])
end

tag = DateTime.new(1.year.ago.year, 1.year.ago.month, 1.year.ago.day)
while tag < DateTime.now do
  puts "tag: " + tag.to_s
  infos = Info.create([
    {benutzer_id: benutzers[0].id, art: 3, datum_uhrzeit: tag + 1.hours, betreff:"Neue Datei für Objekt 1", text:"Für Objekt 1 gibt's eine neue Datei!", datei: "Objekt1\\Sonstiges\\ObjSonstiges2.pdf"},
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
    {objekt: objekts[0], benutzer: benutzers[1], datum: tag, uhrzeit_beginn: (tag + 2.hours).strftime("%H:%M"), uhrzeit_ende: (tag + 10.hours).strftime("%H:%M"), beendet: true}, 
    {objekt: objekts[0], benutzer: benutzers[2], datum: tag, uhrzeit_beginn: (tag + 10.hours).strftime("%H:%M"), uhrzeit_ende: (tag + 18.hours).strftime("%H:%M"), beendet: true}, 
    {objekt: objekts[0], benutzer: benutzers[1], datum: tag, uhrzeit_beginn: (tag + 18.hours).strftime("%H:%M"), uhrzeit_ende: (tag + 26.hours).strftime("%H:%M"), beendet: true}
  ])
  
  schichts.each do |s|
    zeitBeginn = Time.parse(s.uhrzeit_beginn)
    Rapport.create([
      {schicht: s, beschreibung: 'beschr1', ort:'ort1', uhrzeit: (zeitBeginn + 2.hours).strftime("%H:%M"), massnahmen: 'massn1', position: 1}, 
      {schicht: s, beschreibung: 'beschr2', ort:'ort2', uhrzeit: (zeitBeginn + 4.hours).strftime("%H:%M"), massnahmen: 'massn2', position: 2}, 
      {schicht: s, beschreibung: 'beschr3', ort:'ort3', uhrzeit: (zeitBeginn + 6.hours).strftime("%H:%M"), massnahmen: 'massn3', position: 3}
    ])
    wb = WachbuchEintrag.create({schicht: s, besonderheiten: 'bes', schaeden: 'schä', ausruestung_vollzaehlig: true, ausruestung_funktion: false, schluessel_vollzaehlig: true, schluessel_bemerkung: 'schlüBem'})
    Kontrollanruf.create({wachbuch_eintrag: wb, uhrzeit: (zeitBeginn + 2.hours).strftime("%H:%M"), bemerkung: 'bem', objekt: 'obj'})
    Kontrollgang.create({wachbuch_eintrag: wb, uhrzeit: (zeitBeginn + 4.hours).strftime("%H:%M"), bemerkung: 'bem'})
    checklistes = Checkliste.create([
      {schicht: s, checklisten_vorlage: checklisten_vorlages[0], uhrzeit: (zeitBeginn + 3.hours).strftime("%H:%M"), position: 1},
      {schicht: s, checklisten_vorlage: checklisten_vorlages[1], uhrzeit: (zeitBeginn + 5.hours).strftime("%H:%M"), position: 2}
    ])
    ChecklistenWert.create([
      {checkliste: checklistes[0], checklisten_eintrag: checklistes[0].checklisten_vorlage.checklisten_eintrags[0], inhalt: CHECKLISTE_WERT_JA},
      {checkliste: checklistes[0], checklisten_eintrag: checklistes[0].checklisten_vorlage.checklisten_eintrags[1], inhalt: "21.05.2015"},
      {checkliste: checklistes[0], checklisten_eintrag: checklistes[0].checklisten_vorlage.checklisten_eintrags[2], inhalt: (zeitBeginn + 2.hours + 30.minutes).strftime("%H:%M")},
      {checkliste: checklistes[0], checklisten_eintrag: checklistes[0].checklisten_vorlage.checklisten_eintrags[3], inhalt: "test-freitext mit mehreren Wörtern und einem gaaaaaaaaaaaaaaaaaaanzschönlangem Wort!"},
      {checkliste: checklistes[1], checklisten_eintrag: checklistes[1].checklisten_vorlage.checklisten_eintrags[0], inhalt: CHECKLISTE_WERT_NEIN},
      {checkliste: checklistes[1], checklisten_eintrag: checklistes[1].checklisten_vorlage.checklisten_eintrags[1], inhalt: "30.07.2013"}
    ])
  end
  tag = tag + 1.days
end
