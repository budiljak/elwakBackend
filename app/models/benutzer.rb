class Benutzer < ActiveRecord::Base
  has_many :objekt_zuordnungs
  has_many :objekts, through: :objekt_zuordnungs

  
    def setze_objekt_zuordnungen(objekt_ids)
      objekt_zuordnungs.destroy_all
      objekt_ids.each {|value|
        objekt_zuordnungs.create(key => value)
      }
    end
      
end
