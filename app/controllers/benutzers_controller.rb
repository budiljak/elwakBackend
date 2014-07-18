class BenutzersController < ApplicationController
  protect_from_forgery :except => [:create, :update, :destroy]
  respond_to :xml

  # GET /benutzers
  # GET /benutzers.json
  def index
    ts_bis = DateTime.parse(params[:ts_bis])
    if params.has_key?(:ts_von)
      ts_von = DateTime.parse(params[:ts_von])
    else
      n = DateTime.now
      ts_von = DateTime.new(n.year - 1, n.month, n.day)
    end
    @benutzers = Benutzer.where("updated_at > ? and updated_at <= ?", ts_von, ts_bis)
    proc = Proc.new{|options, record| options[:builder].tag!('ts', record.updated_at.iso8601(9)) }
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @benutzers, :except => [:updated_at, :created_at], :dasherize => false, root: "benutzers", :procs => [proc], :include => [:objekt_zuordnungs]}
    end
  end

  # POST /benutzers
  # POST /benutzers.json
  def create
    doc = Nokogiri::XML(request.body.read)
    bNode = doc.xpath('elwak/benutzer')

    @benutzer = Benutzer.new(benutzer_params(bNode))
    if @benutzer.save
      if bNode.xpath('objekt_zuordnungs').length > 0
        objekt_ids = bNode.xpath('objekt_zuordnungs/objekt_id').map{|oz| oz.text.to_s.to_i}
        @benutzer.setze_objekt_zuordnungen(objekt_ids)
      end
      success(@benutzer.id)
    else
      error(@benutzer.errors)
    end
  end

  # PATCH/PUT /benutzers/1
  # PATCH/PUT /benutzers/1.json
  def update
    doc = Nokogiri::XML(request.body.read)
    bNode = doc.xpath('elwak/benutzer')

    @benutzer = Benutzer.find(params[:id])
    
    #Sicherstellen, dass Benutzer synchronisiert wird auch wenn nur Objekt-Zuordnungen anders sind!
    @benutzer.updated_at = DateTime.now 

    if bNode.xpath('objekt_zuordnungs').length > 0
      @benutzer.setze_objekt_zuordnungen(bNode.xpath('objekt_zuordnungs/objekt_id').map{|oz| oz.text.to_s.to_i})
    end
    if @benutzer.update(benutzer_params(bNode))
      success(nil)
    else
      error(@benutzer.errors)
    end
  end

  private
    def benutzer_params(bNode)
      return {
        login: bNode.xpath('login').text.to_s,
        passwort: bNode.xpath('passwort').text.to_s,
        vorname: bNode.xpath('vorname').text.to_s,
        nachname: bNode.xpath('nachname').text.to_s,
        typ: bNode.xpath('typ').text.to_s.to_i,
        inaktiv: bNode.xpath('inaktiv').text.to_s.to_bool
      }
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
