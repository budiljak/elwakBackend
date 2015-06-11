module RapportsHelper
  include SessionsHelper

  def rapport_bezeichner(rapport)
    if rapport.persisted?
      rapport.uhrzeit + " " + rapport.beschreibung
    else
      "(NEU)"
    end
  end

  def rapport_path_for_list(rapport)
    if rapport.persisted?
      if current_schicht && rapport.schicht.id == current_schicht.id
        edit_rapport_path(rapport, format: :html)
      else
        rapport_path(rapport, format: :html)
      end
    else
      new_rapport_path
    end
  end
    
end
