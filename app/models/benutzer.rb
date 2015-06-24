class Benutzer < ActiveRecord::Base
  has_many :objekt_zuordnungs
  has_many :objekts, through: :objekt_zuordnungs

  
  def setze_objekt_zuordnungen(objekt_ids)
    objekt_zuordnungs.destroy_all
    objekt_ids.each {|value|
      objekt_zuordnungs.create(:objekt_id => value)
    }
  end

  def authenticate(password)
    passwort == password
  end

  def nachname_vorname
    nachname + (vorname && vorname.length > 0?", " + vorname : "")
  end

  def nachname_vorname_kurz
    nachname + (vorname && vorname.length > 0?", " + vorname[0]:"")
  end

      
end
