class PdfDateiController < ApplicationController
  protect_from_forgery :except => [:upload]

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
    @pdfs = PdfDatei.where(:objekt_id=>objekt_id).where("updated_at > ? and updated_at <= ?", ts_von, ts_bis)
    puts @pdfs.count
    proc = Proc.new{|options, record| options[:builder].tag!('ts', record.updated_at.iso8601(9)) }
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @pdfs, :except => [:updated_at, :created_at], :dasherize => false, root: "pdf_dateis", :procs => [proc]}
    end
  end
  
  def download
    pdf = PdfDatei.find(params[:id])
    
    send_file pdf.datei.path, :type=>"application/pdf", :disposition=>'attachment'
  end

  def upload
    pdf = PdfDatei.new(pdf_datei_params)
    pdf.name = pdf.datei.file.filename
    pdf.save
    respond_to do |format|
      format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><success />'}
    end
  end

  def loeschen
    doc = Nokogiri::XML(request.body.read)
    pdNode = doc.xpath('elwak/pdf_datei')
    pdf = PdfDatei.new(pdf_datei_params)
    pdf.name = pdNode.xpath('name').text.to_s
    pdf.geloescht = true
    pdf.save
    respond_to do |format|
      format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><success />'}
    end
  end
    

  private
    def pdf_datei_params
      params.permit(:objekt_id, :art, :name, :datei)
    end
  
end
