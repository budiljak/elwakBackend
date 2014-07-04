class Objekt < ActiveRecord::Base
  has_many :objekt_zuordnungs
  has_many :benutzers, through: :objekt_zuordnungs
end
