class ObjektZuordnung < ActiveRecord::Base
  belongs_to :benutzer
  belongs_to :objekt
end

