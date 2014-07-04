class Info < ActiveRecord::Base
  belongs_to :benutzer

  has_many :info_empfaengers
end
