# encoding: UTF-8
require 'nokogiri'
require 'builder'
class SchichtsController < ApplicationController
  include SessionsHelper
  before_action :set_schicht, only: [:show, :edit, :dialog_header, :destroy]

  # GET /schichts
  # GET /schichts.json
  def index
    if request.format.json?
      prepare_schichts_json
    else
      prepare_schichts_xml
    end
    # proc = Proc.new{|options, record| options[:builder].tag!('ts', record.updated_at.iso8601(9)) }
    respond_to do |format|
      format.html # index.html.erb
      format.xml #{render :xml => @schichts, :except => [:updated_at, :created_at], :dasherize => false, root:"schichts", :procs => [proc]}
      format.json
    end
  end

  def new
    @schicht = Schicht.new
    @schicht.datum = Time.zone.today
    n = Time.zone.now
    @schicht.uhrzeit_beginn = n.strftime('%H') + ":00"
    @schicht.uhrzeit_ende = (n + 8.hours).strftime('%H') + ":00"
    render partial: 'form'
  end

  # POST /schichts
  # POST /schichts.json
  def create
    if request.format.js?
      @schicht = Schicht.new(schicht_params)
      # Transform date to utc (compatibility with offline version)
      @schicht.datum = DateTime.new(@schicht.datum.year, @schicht.datum.month, @schicht.datum.day)
      @schicht.benutzer = current_user
      @schicht.objekt = current_objekt
      @schicht.wachbuch_eintrag = WachbuchEintrag.create
      @schicht.save
    else
      doc = Nokogiri::XML(request.body.read)
      sNode = doc.xpath('elwak/schicht')[0]
      @schicht = parseSchicht(sNode)
    end
    respond_to do |format|
      format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><success />'}
      format.js {render action: 'save_success'}
    end
  end

  def finish
    wb = current_schicht.wachbuch_eintrag
    if wb.ausruestung_vollzaehlig.nil? or wb.ausruestung_funktion.nil? or wb.schluessel_vollzaehlig.nil? or current_schicht.checklistes.count == 0 or current_schicht.rapports.count == 0
      render action: 'finish_incomplete'
    elsif current_schicht.update(beendet: true)
      render action: 'save_success'
    else
      render action: 'save_error'
    end
  end
    
  def dialog_header
    render partial: 'dialog_header'
  end

  def current
    s = []
    if (current_schicht)
      s[0] = current_schicht.datum.strftime(FORMAT_SCHICHT_DATUM) + " " + current_schicht.uhrzeit_beginn + "-" + current_schicht.uhrzeit_ende
    end
    respond_to do |format|
      format.json {render json: s}
    end
  end
    

  # DELETE /schichts/1
  # DELETE /schichts/1.json
  def destroy
    @schicht.destroy
    respond_to do |format|
      format.html { redirect_to schichts_url }
      format.json { head :no_content }
    end
  end

  private
    def prepare_schichts_xml
      ts_bis = DateTime.parse(params[:ts_bis])
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
      @schichts = Schicht.where(:objekt_id => objekt_id).where("updated_at > ? and updated_at <= ?", ts_von, ts_bis).where(beendet: true)
    end

    def prepare_schichts_json
        n = DateTime.now
        ts_von = DateTime.new(n.year - 1, n.month, n.day)
        @schichts = Schicht.includes(:benutzer).eager_load("wachbuch_eintrag").where(:objekt_id => current_objekt.id).where("schichts.updated_at > ?", ts_von).where("beendet = ? or benutzer_id=?",true, current_user.id).order(datum: :desc, uhrzeit_beginn: :desc)
    end
  
    def parseSchicht(sNode)
      s_props = {
        objekt_id: sNode.xpath('objekt_id').text.to_s, 
        benutzer_id: sNode.xpath('benutzer_id').text.to_s, 
        datum: sNode.xpath('datum').text.to_s, 
        uhrzeit_beginn: sNode.xpath('uhrzeit_beginn').text.to_s, 
        uhrzeit_ende: sNode.xpath('uhrzeit_ende').text.to_s,
        beendet: true
      }
      puts sNode.xpath('server_id').text
      if sNode.xpath('server_id').text.length > 0 then
        s = Schicht.find(sNode.xpath('server_id')[0].text.to_s)
        s.wachbuch_eintrag.destroy
        for r in s.rapports do
          r.destroy
        end
        for c in s.checklistes do
          c.destroy
        end
        s.update(s_props)
      else
        s = Schicht.new(s_props)
      end
      sNode.xpath('rapports/rapport').each do |rNode|
        r = Rapport.new({
          schicht: s,
          beschreibung: rNode.xpath('beschreibung').text.to_s, 
          ort: rNode.xpath('ort').text.to_s, 
          uhrzeit: rNode.xpath('uhrzeit').text.to_s, 
          massnahmen: rNode.xpath('massnahmen').text.to_s, 
          position: rNode.xpath('position').text.to_s
        })
        r.save
      end
      s.save
      wbNode = sNode.xpath('wachbuch_eintrag')
      parseWachbuchEintrag(wbNode, s)
      sNode.xpath('checklistes/checkliste').each do |cNode|
        parseCheckliste(cNode, s)
      end
      return s
    end

    def parseWachbuchEintrag(wbNode, s)
      wb = WachbuchEintrag.new({
        besonderheiten: wbNode.xpath('besonderheiten').text.to_s, 
        schaeden: wbNode.xpath('schaeden').text.to_s, 
        ausruestung_vollzaehlig: wbNode.xpath('ausruestung_vollzaehlig').text.to_bool, 
        ausruestung_funktion: wbNode.xpath('ausruestung_funktion').text.to_bool, 
        schluessel_vollzaehlig: wbNode.xpath('schluessel_vollzaehlig').text.to_bool, 
        schluessel_bemerkung: wbNode.xpath('schluessel_bemerkung').text.to_s, 
        schicht: s
      })
      wb.save
      wbNode.xpath('kontrollanrufs/kontrollanruf').each do |kaNode|
        ka = Kontrollanruf.new({
          wachbuch_eintrag: wb,
          uhrzeit: kaNode.xpath('uhrzeit').text.to_s,
          objekt: kaNode.xpath('objekt').text.to_s,
          bemerkung: kaNode.xpath('bemerkung').text.to_s,
          position: kaNode.xpath('position').text.to_s
        })
        ka.save
      end
      wbNode.xpath('kontrollgangs/kontrollgang').each do |kgNode|
        kg = Kontrollgang.new({
          wachbuch_eintrag: wb,
          uhrzeit: kgNode.xpath('uhrzeit').text.to_s,
          bemerkung: kgNode.xpath('bemerkung').text.to_s,
          position: kgNode.xpath('position').text.to_s
        })
        kg.save
      end
    end

    def parseCheckliste(cNode, s)
        c = Checkliste.new({
          schicht: s,
          checklisten_vorlage_id: cNode.xpath('checklisten_vorlage_id').text.to_s, 
          uhrzeit: cNode.xpath('uhrzeit').text.to_s, 
          position: cNode.xpath('position').text.to_s
        })
        c.save
        cNode.xpath('checklisten_werts/checklisten_wert').each do |cwNode|
          cw = ChecklistenWert.new({
            checkliste: c,
            checklisten_eintrag_id: cwNode.xpath('checklisten_eintrag_id').text.to_s, 
            inhalt: cwNode.xpath('inhalt').text.to_s
          })
          cw.save
        end
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_schicht
      @schicht = Schicht.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schicht_params
      params.require(:schicht).permit(:objekt_id, :benutzer_id, :datum, :uhrzeit_beginn, :uhrzeit_ende)
    end
end
