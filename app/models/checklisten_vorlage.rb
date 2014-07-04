class ChecklistenVorlage < ActiveRecord::Base
  belongs_to :objekt

  has_many :checklisten_eintrags
end
