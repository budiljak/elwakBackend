class ChecklistenWert < ActiveRecord::Base
  belongs_to :checkliste
  belongs_to :checklisten_eintrag
end
