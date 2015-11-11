class InfoEmpfaengersController < ApplicationController
  def index
    ts_bis = DateTime.parse(params[:ts_bis])
    if params.has_key?(:benutzer_id)
      benutzer_id = params[:benutzer_id].to_i
    else
      benutzer_id = nil
    end
    ts_max_alter = DateTime.new(n.year - 1, n.month, n.day)
    if params.has_key?(:ts_von)
      ts_von = DateTime.parse(params[:ts_von])
    else
      n = DateTime.now
      ts_von = ts_max_alter
    end
    ieEmpfangen = InfoEmpfaenger.joins(:info).where("info_empfaengers.benutzer_id=?", benutzer_id).where("info_empfaengers.updated_at > ? and info_empfaengers.updated_at <= ?", ts_von, ts_bis).where("infos.updated_at > ?", ts_max_alter)
    ieGesendet = InfoEmpfaenger.joins(:info).where("infos.benutzer_id = ?", benutzer_id.to_i).where("info_empfaengers.updated_at > ? and info_empfaengers.updated_at <= ?", ts_von, ts_bis).where("infos.updated_at > ?", ts_max_alter)

    ids = []
    @info_empfaengers = []
    ieEmpfangen.each do |ie|
      if not ids.include?(ie.id)
        ids.push(ie.id)
        @info_empfaengers.push(ie)
      end
    end
    ieGesendet.each do |ie|
      if not ids.include?(ie.id)
        ids.push(ie.id)
        @info_empfaengers.push(ie)
      end
    end
    proc = Proc.new{|options, record| options[:builder].tag!('ts', record.updated_at.iso8601(9)) }
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @info_empfaengers, :except => [:updated_at, :created_at], :dasherize => false, root:"info_empfaengers", :procs => [proc]}
    end
  end

  
  def update
    #doc = Nokogiri::XML(request.body.read)
    #iNode = doc.xpath('elwak/info_empfaenger')
    #update_params = {
      #id: iNode.xpath('id').text.to_s,
      #gelesen: iNode.xpath('gelesen').text.to_s.to_bool
    #}
    @infoEmpfaenger = InfoEmpfaenger.find(params[:id])

    respond_to do |format|
      if @infoEmpfaenger.update(gelesen: true)
        format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><success />'}
      else
        format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><error />'}
      end
    end
  end
    
end
