class Schicht < ActiveRecord::Base
  belongs_to :objekt
  belongs_to :benutzer

  has_many :rapports
  has_one :wachbuch_eintrag
  has_many :checklistes
  
end
