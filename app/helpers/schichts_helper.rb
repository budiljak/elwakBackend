module SchichtsHelper

  def schicht_bezeichner(schicht)
    schicht.datum.strftime(FORMAT_SCHICHT_DATUM) + " " + schicht.uhrzeit_beginn + "-" + schicht.uhrzeit_ende + " (" + schicht.benutzer.nachname + ")"
  end
end
