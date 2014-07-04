class ObjektsController < ApplicationController
  before_action :set_objekt, only: [:show, :edit, :update, :destroy]

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
    @objekt = Objekt.new(lese_params("objekt"))
    if @objekt.save
      success(@objekt.id)
    else
      error(@objekt.errors)
    end
  end

  def update
    @objekt = Objekt.find(params[:id])
    if @objekt.update(lese_params("objekt"))
      success
    else
      error(@objekt.errors)
    end
  end

  private
    def lese_params(root_tag)
      xml = request.body.read
      return Hash.from_xml(xml)['elwak'][root_tag]
    end

    def success(id)
      @antwort = ""
      xml = Builder::XmlMarkup.new( :target => @antwort, :indent => 2 )
      xml.instruct!

      if id
        xml.success id
      else
        xml.success
      end
      respond_to do |format|
        format.xml {render :xml => @antwort}
      end
    end
    
    def error(message)
      @antwort = ""
      xml = Builder::XmlMarkup.new( :target => @antwort, :indent => 2 )
      xml.instruct!

      if message
        xml.error message
      else
        xml.error
      end
      respond_to do |format|
        format.xml {render :xml => @antwort}
      end
    end
      
end
