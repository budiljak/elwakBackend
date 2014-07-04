class ChecklistenVorlagesController < ApplicationController
  before_action :set_checklisten_vorlage, only: [:show, :edit, :update, :destroy]

  # GET /checklisten_vorlages
  # GET /checklisten_vorlages.json
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
    @checklisten_vorlages = ChecklistenVorlage.where(:objekt_id => objekt_id).where("updated_at > ? and updated_at <= ?", ts_von, ts_bis)
    proc = Proc.new{|options, record| options[:builder].tag!('ts', record.updated_at.iso8601(9)) }
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @checklisten_vorlages, :except => [:updated_at, :created_at], :dasherize => false, root:"checklisten_vorlages", :procs => [proc], :include => [:checklisten_eintrags]}
    end
  end

  # POST /checklisten_vorlages
  # POST /checklisten_vorlages.json
  def create
    doc = Nokogiri::XML(request.body.read)
    cvNode = doc.xpath('elwak/checklisten_vorlage')
    cv = ChecklistenVorlage.new({
      objekt_id: cvNode.xpath('objekt_id').text.to_s, 
      bezeichner: cvNode.xpath('bezeichner').text.to_s, 
      version: cvNode.xpath('version').text.to_s.to_i, 
      inaktiv: cvNode.xpath('inaktiv').text.to_s.to_bool 
    })
    cv.save
    puts "checklisten_eintrags: " + cvNode.xpath('checklisten_eintrags/checklisten_eintrag').to_s

    cvNode.xpath('checklisten_eintrags/checklisten_eintrag').each do |ceNode|
      ce = ChecklistenEintrag.new({
        checklisten_vorlage_id: cv.id,
        bezeichner: ceNode.xpath('bezeichner').text.to_s,
        was: ceNode.xpath('was').text.to_s,
        wann: ceNode.xpath('wann').text.to_s,
        typ: ceNode.xpath('typ').text.to_s.to_i,
        position: ceNode.xpath('position').text.to_s.to_i
      })
      ce.save
    end

    respond_to do |format|
      format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><success />'}
    end
  end

  # PATCH/PUT /checklisten_vorlages/1
  # PATCH/PUT /checklisten_vorlages/1.json
  def update
    doc = Nokogiri::XML(request.body.read)
    cvNode = doc.xpath('elwak/checklisten_vorlage')

    update_params = {inaktiv: cvNode.xpath('inaktiv').text.to_s.to_bool}
    respond_to do |format|
      if @checklisten_vorlage.update(update_params)
        format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><success />'}
      else
        format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><error />'}
      end
    end
  end

  # DELETE /checklisten_vorlages/1
  # DELETE /checklisten_vorlages/1.json
  def destroy
    @checklisten_vorlage.destroy
    respond_to do |format|
      format.html { redirect_to checklisten_vorlages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checklisten_vorlage
      @checklisten_vorlage = ChecklistenVorlage.find(params[:id])
    end

end
