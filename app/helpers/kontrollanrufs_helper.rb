module KontrollanrufsHelper
  def kontrollanruf_path_for_list(kontrollanruf)
    if current_schicht && kontrollanruf.wachbuch_eintrag.schicht.id == current_schicht.id
      edit_kontrollanruf_path(kontrollanruf, format: :html)
    else
      kontrollanruf_path(kontrollanruf, format: :html)
    end
  end
      
end
