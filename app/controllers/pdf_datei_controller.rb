class PdfDateiController < ApplicationController
  include SessionsHelper
  protect_from_forgery :except => [:upload]
  before_filter :logged_in_user, :only => [:show]

  def index
    if request.format.json?
      prepare_pdfs_json
    elsif request.format.html?
      prepare_pdfs_html
    else
      prepare_pdfs_xml
    end
    respond_to do |format|
      format.xml {
        proc = Proc.new{|options, record| options[:builder].tag!('ts', record.updated_at.iso8601(9)) }
        render :xml => @pdfs, :except => [:updated_at, :created_at], :dasherize => false, root: "pdf_dateis", :procs => [proc]
      }
      format.json
      format.html {render layout: false}
    end
  end
  
  def show
    pdf = PdfDatei.find(params[:id])
    puts (not pdf.objekt == nil)
    puts (not pdf.objekt == current_objekt)
    if (not pdf.objekt == nil) and (not pdf.objekt == current_objekt)
      redirect_to login_url
      return
    end
    
    send_file pdf.datei.path, :type=>"application/pdf", :disposition=>'inline'
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
    params = pdf_datei_params
    params[:name] = pdNode.xpath('name').text.to_s
    PdfDatei.where(params).each do |p|
      p.destroy
    end
    pdf = PdfDatei.new(params)
    pdf.geloescht = true
    pdf.save
    respond_to do |format|
      format.xml {render :xml => '<?xml version="1.0" encoding="UTF-8"?><success />'}
    end
  end
    

  private
    def prepare_pdfs_html
      arb_anw_allg = PdfDatei.where(art: PDF_DATEI_ART_ARB_ANW_ALLG).where(geloescht: false).order(:name)
      arb_anw_obj = PdfDatei.where(art: PDF_DATEI_ART_ARB_ANW_OBJ).where(geloescht: false).where(objekt_id: current_objekt.id).order(:name)
      sonst_obj = PdfDatei.where(art: PDF_DATEI_ART_SONST_OBJ).where(geloescht: false).where(objekt_id: current_objekt.id).order(:name)

      @pdfs = []
      if arb_anw_allg.length > 0
        @pdfs.push(['Arbeitsanweisungen - Allgemein', arb_anw_allg.map{|p| [p.name, make_windows_path(p)]}])
      end
      if arb_anw_obj.length > 0
        @pdfs.push(['Arbeitsanweisungen - Objekt', arb_anw_obj.map{|p| [p.name, make_windows_path(p)]}])
      end
      if sonst_obj.length > 0
        @pdfs.push(['Sonstiges - Objekt', sonst_obj.map{|p| [p.name, make_windows_path(p)]}])
      end
      puts @pdfs
    end

    def make_windows_path(pdf)
      if pdf.art.to_s == PDF_DATEI_ART_ARB_ANW_ALLG
        return "AllgemeineArbeitsanweisungen\\" + pdf.name
      else
        prefix = "Objekt" + pdf.objekt_id.to_s + "\\"
        if pdf.art.to_s == PDF_DATEI_ART_ARB_ANW_OBJ
          return prefix +  "Arbeitsanweisungen\\" + pdf.name
        else
          return prefix +  "Sonstiges\\" + pdf.name
        end
      end
    end
    
    def prepare_pdfs_json
      art = params[:art]
      if art == PDF_DATEI_ART_ARB_ANW_ALLG
        @pdfs = PdfDatei.where(art: art).where(geloescht: false).order(:name)
      else
        @pdfs = PdfDatei.where(art: art).where(geloescht: false).where(objekt_id: current_objekt.id).order(:name)
      end
    end

    def prepare_pdfs_xml
      ts_bis = DateTime.parse(params[:ts_bis])
      if params.has_key?(:objekt_id)
        objekt_id = params[:objekt_id].to_i
      else
        objekt_id = nil
      end
      if params.has_key?(:ts_von)
        ts_von = DateTime.parse(params[:ts_von])
        @pdfs = PdfDatei.where(:objekt_id=>objekt_id).where("updated_at > ? and updated_at <= ?", ts_von, ts_bis)
      else
        @pdfs = PdfDatei.where(:objekt_id=>objekt_id).where("updated_at <= ?", ts_bis)
      end
    end

    def pdf_datei_params
      params.permit(:objekt_id, :art, :name, :datei)
    end
  
    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end
end
