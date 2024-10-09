class Info < ActiveRecord::Base
  belongs_to :benutzer

  has_many :info_empfaengers, dependent: :destroy
  has_many :benutzers, through: :info_empfaengers

  def has_datei?
    (datei && datei.length > 0)
  end

  def datei_art
    if !has_datei?
      logger.error("Info.datei_art aufgerufen, obwohl keine Datei enthalten!")
      return 
    end
    
    if datei.start_with?("AllgemeineArbeitsanweisungen")
      return PDF_DATEI_ART_ARB_ANW_ALLG
    elsif datei.include?("\\Arbeitsanweisungen\\")
      return PDF_DATEI_ART_ARB_ANW_OBJ
    elsif datei.include?("\\Sonstiges\\")
      return PDF_DATEI_ART_SONST_OBJ
    else
      logger.error("Konnte Datei-Art nicht bestimmen!")
      return "-1"
    end
  end

  def datei_objekt_id
    if !has_datei?
      logger.error("Info hat keine Datei!")
      return -1
    end

    if datei_art == PDF_DATEI_ART_ARB_ANW_ALLG
      logger.error("Datei hat keine Objekt-ID! (Art ist 'Allgemeine Arbeitsanweisungen')")
      return -1
    end

    m = datei.match("^Objekt(.*)\\\\.*\\\\")

    if m == nil || m.length < 2
      logger.error("ID nicht im Datei-String gefunden!")
      return -1
    else
      return m[1].to_i
    end
  end

  def dateiname
    m = datei.match("([^\\\\]*)$")
    if m.length < 2
      logger.error("Fehler beim Suchen des Dateinamens! (Reg. Ausdruck hat nichts gefunden?!)")
      return datei
    else
      return m[1]
    end
  end

  def dateiname_mit_objekt
    if datei_art == PDF_DATEI_ART_ARB_ANW_ALLG
      return dateiname
    else
      objekt = Objekt.find_by_id(datei_objekt_id)
      if objekt
        return dateiname + " (" + objekt.bezeichner + ")"
      else
        return dateiname
      end
    end
  end
      
end
