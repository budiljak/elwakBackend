class ChecklistenWert < ActiveRecord::Base
  belongs_to :checkliste
  belongs_to :checklisten_eintrag

  def is_ja_nein?
    checklisten_eintrag.is_ja_nein?
  end
  
  def is_datum?
    checklisten_eintrag.is_datum?
  end
  
  def is_uhrzeit?
    checklisten_eintrag.is_uhrzeit?
  end
  
  def is_freitext?
    checklisten_eintrag.is_freitext?
  end

end
