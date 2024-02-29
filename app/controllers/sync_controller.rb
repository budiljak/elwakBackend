# encoding: UTF-8
class SyncController < ApplicationController

  def allgemein
    ts_bis = nil
    
    if params.has_key?(:ts_von)
      ts_von = DateTime.parse(params[:ts_von])
      benutzers = Benutzer.where("updated_at > ?", ts_von)
      objekt_zuordnungs = ObjektZuordnung.where("updated_at > ?", ts_von)
      objekts = Objekt.where("updated_at > ?", ts_von)
      pdf_dateis = PdfDatei.where(:objekt_id => nil).where("updated_at > ?", ts_von)
    else
      benutzers = Benutzer.all
      objekt_zuordnungs = ObjektZuordnung.all
      objekts = Objekt.all
      pdf_dateis = PdfDatei.all
    end

    if benutzers.count > 0
      new_max = benutzers.maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if objekt_zuordnungs.count > 0
      new_max = objekt_zuordnungs.maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if objekts.count > 0
      new_max = objekts.maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if pdf_dateis.count > 0
      new_max = pdf_dateis.maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if ts_bis
      sync ts_bis
    else
      no_sync
    end
  end

  def benutzer
    ts_bis = nil
    if params.has_key?(:benutzer_id)
      benutzer_id = params[:benutzer_id].to_i
    else
      benutzer_id = nil
    end
    
    if params.has_key?(:ts_von)
      ts_von = DateTime.parse(params[:ts_von])
    else
      ts_von = DateTime.now - 1.year
    end
    infos_empfangen = Info.joins(:info_empfaengers).where("info_empfaengers.benutzer_id = ?", benutzer_id.to_i).where("infos.updated_at > ?", ts_von)
    infos_gesendet = Info.where("benutzer_id = ?", benutzer_id.to_i).where("infos.updated_at > ?", ts_von)
    info_empfaengers_empfagene = InfoEmpfaenger.where("benutzer_id = ?", benutzer_id.to_i).where("info_empfaengers.updated_at > ?", ts_von)
    info_empfaengers_gesendete = InfoEmpfaenger.joins(:info).where("infos.benutzer_id = ?", benutzer_id.to_i).where("info_empfaengers.updated_at > ?", ts_von)

    # Infos mit Benutzer als Empfänger
    if infos_empfangen.count > 0
      max_info = infos_empfangen.maximum(:updated_at)
      if !ts_bis or max_info > ts_bis
        ts_bis = max_info
      end
    end
    # Infos mit Benutzer als absender
    if infos_gesendet.count > 0
      max_info = infos_gesendet.maximum(:updated_at)
      if !ts_bis or max_info > ts_bis
        ts_bis = max_info
      end
    end
    # Neuer Gelesen-Status für empfangene Infos ? 
    if info_empfaengers_empfagene.count > 0
      max_info = info_empfaengers_empfagene.maximum(:updated_at)
      if !ts_bis or max_info > ts_bis
        ts_bis = max_info
      end
    end
    # Neuer Gelesen-Status für gelesene Infos ? 
    if info_empfaengers_gesendete.count > 0
      max_info = info_empfaengers_gesendete.maximum('info_empfaengers.updated_at')
      if !ts_bis or max_info > ts_bis
        ts_bis = max_info
      end
    end
    if ts_bis
      sync ts_bis
    else
      no_sync
    end
  end
  
  def objekt
    ts_bis = nil
    if params.has_key?(:objekt_id)
      objekt_id = params[:objekt_id].to_i
    else
      objekt_id = nil
    end
    
    if params.has_key?(:ts_von)
      ts_von = DateTime.parse(params[:ts_von])
      checklisten_vorlages = ChecklistenVorlage.where(:objekt_id => objekt_id).where("updated_at > ?", ts_von)
      pdf_dateis = PdfDatei.where(:objekt_id => objekt_id).where("updated_at > ?", ts_von)
    else
      checklisten_vorlages = ChecklistenVorlage.where(:objekt_id => objekt_id)
      pdf_dateis = PdfDatei.where(:objekt_id => objekt_id)
      ts_von = DateTime.now - 1.year
    end
    schichts = Schicht.where(:objekt_id => objekt_id).where("updated_at > ?", ts_von).where(beendet: true)
    if checklisten_vorlages.count > 0
      new_max = checklisten_vorlages.maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if schichts.count > 0
      new_max = schichts.maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if pdf_dateis.count > 0
      new_max = pdf_dateis.maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if ts_bis
      sync ts_bis
    else
      no_sync
    end
  end
  
  private
    def sync(ts_sync)
      @antwort = ts_sync.iso8601(9)
      
      respond_to do |format|
        format.xml {render "sync/sync"}
      end
    end

    def no_sync
      respond_to do |format|
        format.xml {render "sync/no_sync"}
      end
    end
end
