module ChecklistesHelper
  def checkliste_bezeichner(checkliste)
    if checkliste.persisted?
      checkliste.uhrzeit + " " + checkliste.checklisten_vorlage.bezeichner
    else
      "(NEU)"
    end
  end

  def checkliste_path_for_list(checkliste)
    if checkliste.persisted?
      if current_schicht && checkliste.schicht.id == current_schicht.id
        edit_checkliste_path(checkliste, format: :html)
      else
        checkliste_path(checkliste, format: :html)
      end
    else
      new_checkliste_path
    end
  end
    
  def delete_checkliste_path_for_list(checkliste)
    if checkliste.persisted? && current_schicht && checkliste.schicht.id == current_schicht.id
        checkliste_path(checkliste, format: :js)
    else
      ""
    end
  end
    
  
end
