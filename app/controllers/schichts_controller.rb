# encoding: UTF-8
require 'nokogiri'
require 'builder'
class SchichtsController < ApplicationController
  before_action :set_schicht, only: [:show, :edit, :update, :destroy]

  # GET /schichts
  # GET /schichts.json
  def index
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
    @schichts = Schicht.where(:objekt_id => objekt_id).where("updated_at > ? and updated_at <= ?", ts_von, ts_bis)
    proc = Proc.new{|options, record| options[:builder].tag!('ts', record.updated_at.iso8601(9)) }
    respond_to do |format|
      format.html # index.html.erb
      format.xml #{render :xml => @schichts, :except => [:updated_at, :created_at], :dasherize => false, root:"schichts", :procs => [proc]}
    end
  end

  # POST /schichts
  # POST /schichts.json
  def create
    #@schicht = Schicht.new(schicht_params)
    doc = Nokogiri::XML(request.body.read)
    sNode = doc.xpath('elwak/schicht')[0]
    @schicht = parseSchicht(sNode)
    respond_to do |format|
      format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><success />'}
    end
  end

  # PATCH/PUT /schichts/1
  # PATCH/PUT /schichts/1.json
  def update
    respond_to do |format|
      if @schicht.update(schicht_params)
        format.html { redirect_to @schicht, notice: 'Schicht was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @schicht.errors, status: :unprocessable_entity }
      end
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
    def parseSchicht(sNode)
      s = Schicht.new({
        objekt_id: sNode.xpath('objekt_id').text.to_s, 
        benutzer_id: sNode.xpath('benutzer_id').text.to_s, 
        datum: sNode.xpath('datum').text.to_s, 
        uhrzeit_beginn: sNode.xpath('uhrzeit_beginn').text.to_s, 
        uhrzeit_ende: sNode.xpath('uhrzeit_ende').text.to_s
      })
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
      puts "wbNode: " + wbNode.to_s
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
        ausruestung_vollzaehlig: wbNode.xpath('ausruestung_vollzaehlig').text.to_s, 
        ausruestung_funktion: wbNode.xpath('ausruestung_funktion').text.to_s, 
        schluessel_vollzaehlig: wbNode.xpath('schluessel_vollzaehlig').text.to_s, 
        schluessel_bemerkung: wbNode.xpath('schluessel_bemerkung').text.to_s, 
        schicht: s
      })
      puts "wb.ausruestung_vollzaehlig: " + wb.ausruestung_vollzaehlig.to_s
      wb.save
      wbNode.xpath('kontrollanrufs').each do |kaNode|
        ka = Kontrollanruf.new({
          wachbuch_eintrag: wb,
          uhrzeit: kaNode.xpath('uhrzeit').text.to_s,
          objekt: kaNode.xpath('objekt').text.to_s,
          bemerkung: kaNode.xpath('bemerkung').text.to_s,
          position: kaNode.xpath('position').text.to_s
        })
        ka.save
      end
      wbNode.xpath('kontrollgangs').each do |kgNode|
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
