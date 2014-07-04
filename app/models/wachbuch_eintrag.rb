class WachbuchEintrag < ActiveRecord::Base
  belongs_to :schicht

  has_many :kontrollanrufs
  has_many :kontrollgangs
end
