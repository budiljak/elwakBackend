module KontrollgangsHelper
  def kontrollgang_path_for_list(kontrollgang)
    if current_schicht && kontrollgang.wachbuch_eintrag.schicht.id == current_schicht.id
      edit_kontrollgang_path(kontrollgang, format: :html)
    else
      kontrollgang_path(kontrollgang, format: :html)
    end
  end
   
end
