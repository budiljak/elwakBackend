# encoding: UTF-8
class SyncController < ApplicationController

  def allgemein
    ts_bis = nil
    
    if params.has_key?(:ts_von)
      ts_von = DateTime.parse(params[:ts_von])
    else
      n = DateTime.now
      ts_von = DateTime.new(n.year - 1, n.month, n.day)
    end
    puts "ts_von: " + ts_von.to_s
    if Benutzer.where("updated_at > ?", ts_von).count > 0
      new_max = Benutzer.where("updated_at > ?", ts_von).maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if ObjektZuordnung.where("updated_at > ?", ts_von).count > 0
      new_max = ObjektZuordnung.where("updated_at > ?", ts_von).maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if Objekt.where("updated_at > ?", ts_von).count > 0
      new_max = Objekt.where("updated_at > ?", ts_von).maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if PdfDatei.where(:objekt_id => nil).where("updated_at > ?", ts_von).count > 0
      new_max = PdfDatei.where(:objekt_id => nil).where("updated_at > ?", ts_von).maximum(:updated_at)
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
      n = DateTime.now
      ts_von = DateTime.new(n.year - 1, n.month, n.day)
    end
    # Infos mit Benutzer als Empfänger
    if Info.joins(:info_empfaengers).where("info_empfaengers.benutzer_id = ?", benutzer_id.to_i).where("infos.updated_at > ?", ts_von).count > 0
      max_info = Info.joins(:info_empfaengers).where("info_empfaengers.benutzer_id = ?", benutzer_id.to_i).where("infos.updated_at > ?", ts_von).maximum(:updated_at)
      if !ts_bis or max_info > ts_bis
        ts_bis = max_info
      end
    end
    # Infos mit Benutzer als absender
    if Info.where("benutzer_id = ?", benutzer_id.to_i).where("infos.updated_at > ?", ts_von).count > 0
      max_info = Info.where("benutzer_id = ?", benutzer_id.to_i).where("infos.updated_at > ?", ts_von).maximum(:updated_at)
      if !ts_bis or max_info > ts_bis
        ts_bis = max_info
      end
    end
    # Neuer Gelesen-Status für empfangene Infos ? 
    if InfoEmpfaenger.where("benutzer_id = ?", benutzer_id.to_i).where("info_empfaengers.updated_at > ?", ts_von).count > 0
      max_info = InfoEmpfaenger.where("benutzer_id = ?", benutzer_id.to_i).where("info_empfaengers.updated_at > ?", ts_von).maximum(:updated_at)
      if !ts_bis or max_info > ts_bis
        ts_bis = max_info
      end
    end
    # Neuer Gelesen-Status für gelesene Infos ? 
    if InfoEmpfaenger.joins(:info).where("infos.benutzer_id = ?", benutzer_id.to_i).where("info_empfaengers.updated_at > ?", ts_von).count > 0
      max_info = InfoEmpfaenger.joins(:info).where("infos.benutzer_id = ?", benutzer_id.to_i).where("info_empfaengers.updated_at > ?", ts_von).maximum('info_empfaengers.updated_at')
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
    else
      n = DateTime.now
      ts_von = DateTime.new(n.year - 1, n.month, n.day)
    end
    if ChecklistenVorlage.where(:objekt_id => objekt_id).where("updated_at > ?", ts_von).count > 0
      new_max = ChecklistenVorlage.where(:objekt_id => objekt_id).where("updated_at > ?", ts_von).maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if Schicht.where(:objekt_id => objekt_id).where("updated_at > ?", ts_von).count > 0
      new_max = Schicht.where(:objekt_id => objekt_id).where("updated_at > ?", ts_von).maximum(:updated_at)
      if !ts_bis or new_max > ts_bis
        ts_bis = new_max
      end
    end
    if PdfDatei.where(:objekt_id => objekt_id).where("updated_at > ?", ts_von).count > 0
      new_max = PdfDatei.where(:objekt_id => objekt_id).where("updated_at > ?", ts_von).maximum(:updated_at)
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
