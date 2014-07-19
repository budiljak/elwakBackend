class ObjektsController < ApplicationController
  # GET /objekts
  # GET /objekts.json
  def index
    ts_bis = DateTime.parse(params[:ts_bis])
    if params.has_key?(:ts_von)
      ts_von = DateTime.parse(params[:ts_von])
    else
      n = DateTime.now
      ts_von = DateTime.new(n.year - 1, n.month, n.day)
    end
    @objekts = Objekt.where("updated_at > ? and updated_at <= ?", ts_von, ts_bis)
    proc = Proc.new{|options, record| options[:builder].tag!('ts', record.updated_at.iso8601(9)) }
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @objekts, :except => [:updated_at, :created_at], :dasherize => false, root:"objekts", :procs => [proc]}
    end
  end

  def create
    @objekt = Objekt.new(objekt_params())
    respond_to do |format|
      if @objekt.save
        format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><success />'}
      else
        format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><error />'}
      end
    end
  end

  def update
    @objekt = Objekt.find(params[:id])
    respond_to do |format|
      if @objekt.update(objekt_params())
        format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><success />'}
      else
        format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><error />'}
      end
    end
  end

  private
    def objekt_params()
      doc = Nokogiri::XML(request.body.read)
      oNode = doc.xpath('elwak/objekt')
      return {
        bezeichner: oNode.xpath('bezeichner').text.to_s,
        inaktiv: oNode.xpath('inaktiv').text.to_s.to_bool
      }
    end
    
end
