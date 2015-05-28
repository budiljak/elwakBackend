module ChecklistesHelper
  def checkliste_bezeichner(checkliste)
    checkliste.uhrzeit + " " + checkliste.checklisten_vorlage.bezeichner
  end
end
