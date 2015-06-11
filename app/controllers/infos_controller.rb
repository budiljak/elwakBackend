class InfosController < ApplicationController
  include SessionsHelper
  before_action :set_info, only: [:show, :edit, :update, :destroy]

  # GET /infos
  # GET /infos.json
  def index
    if request.format.json?
      prepare_infos_json
    else
      prepare_infos_xml
    end
    # proc = Proc.new{|options, record| options[:builder].tag!('ts', record.updated_at.iso8601(9)) }
    respond_to do |format|
      format.xml # {render :xml => @infos, :except => [:updated_at, :created_at], :dasherize => false, root:"infos", :procs => [proc]}
      format.json # {render json: @infos}
    end
  end
  
  def show
    respond_to do |format|
      format.html {render layout: false}
    end
  end

  # POST /infos
  # POST /infos.json
  def create
    doc = Nokogiri::XML(request.body.read)
    iNode = doc.xpath('elwak/info')[0]
    @info = parse_info(iNode)
    respond_to do |format|
      format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><success />'}
    end
  end

  # DELETE /infos/1
  # DELETE /infos/1.json
  def destroy
    @info.destroy
    respond_to do |format|
      format.html { redirect_to infos_url }
      format.json { head :no_content }
    end
  end

  def embeddable_list
    
    
  end

  private
    def prepare_infos_xml
      ts_bis = DateTime.parse(params[:ts_bis])
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
      infos_empfangen = Info.joins(:info_empfaengers).where("info_empfaengers.benutzer_id = ?", benutzer_id).where("infos.updated_at > ? and infos.updated_at <= ?", ts_von, ts_bis)
      infos_gesendet = Info.where("benutzer_id = ?", benutzer_id).where("infos.updated_at > ? and infos.updated_at <= ?", ts_von, ts_bis)
      ids = []
      @infos = []
      infos_empfangen.each do |i|
        if not ids.include?(i.id)
          ids.push(i.id)
          @infos.push(i)
        end
      end
      infos_gesendet.each do |i|
        if not ids.include?(i.id)
          ids.push(i.id)
          @infos.push(i)
        end
      end
    end

    def prepare_infos_json
      n = DateTime.now
      ts_von = DateTime.new(n.year - 1, n.month, n.day)
      @infos = Info.eager_load(:info_empfaengers).includes(:benutzer).where("info_empfaengers.benutzer_id = ?", current_user.id).where("infos.updated_at > ?", ts_von).order(datum_uhrzeit: :desc)
    end
      
    def parse_info(iNode)
      puts "datUhr: " +  iNode.xpath('datum_uhrzeit').text.to_s,
      i = Info.new({
        benutzer_id: iNode.xpath('benutzer_id').text.to_s,
        art: iNode.xpath('art').text.to_s,
        datum_uhrzeit: iNode.xpath('datum_uhrzeit').text.to_s,
        betreff: iNode.xpath('betreff').text.to_s,
        text: iNode.xpath('text').text.to_s,
        datei: iNode.xpath('datei').text.to_s
      })
      i.save
      iNode.xpath('info_empfaengers/info_empfaenger').each do |eNode|
        e = InfoEmpfaenger.new({
          info_id: i.id,
          benutzer_id: eNode.xpath('benuzter_id').text.to_s,
          gelesen: false
        })
        e.save
      end
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_info
      @info = Info.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def info_params
      params.require(:info).permit(:benutzer_id, :art, :datum, :betreff, :text, :datei)
    end
end
