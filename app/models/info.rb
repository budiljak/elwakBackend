class Info < ActiveRecord::Base
  belongs_to :benutzer

  has_many :info_empfaengers
  has_many :benutzers, through: :info_empfaengers
end
