class ChecklistenEintrag < ActiveRecord::Base
  belongs_to :checklisten_vorlage

  def is_ja_nein?
    typ == CHECKLISTE_TYP_JA_NEIN
  end
  
  def is_datum?
    typ == CHECKLISTE_TYP_DATUM
  end
  
  def is_uhrzeit?
    typ == CHECKLISTE_TYP_UHRZEIT
  end
  
  def is_freitext?
    typ == CHECKLISTE_TYP_FREITEXT
  end
  
end
