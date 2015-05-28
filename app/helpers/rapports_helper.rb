module RapportsHelper
  def rapport_bezeichner(rapport)
    rapport.uhrzeit + " " + rapport.beschreibung
  end
end
