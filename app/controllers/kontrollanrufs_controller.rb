# encoding: UTF-8
class KontrollanrufsController < ApplicationController
  before_action :set_kontrollanruf, only: [:show, :edit, :update, :destroy]

  def index
    prepare_kontrollanrufs_json
    respond_to do |format|
      format.json
    end
  end

  def new
    @kontrollanruf = Kontrollanruf.new
    @kontrollanruf.wachbuch_eintrag_id = params[:wachbuch_eintrag_id]
    @kontrollanruf.uhrzeit = DateTime.now.strftime(FORMAT_UHRZEIT)
    render partial: "form"
  end
  
  def create
    @kontrollanruf = Kontrollanruf.new(kontrollanruf_params)
    if @kontrollanruf.save
      render action: 'save_success'
    else
      render action: 'save_error'
    end
  end

  def show
    render partial: "form", locals: {readonly: true}
  end

  def edit
    render partial: "form"
  end

  def update
    if @kontrollanruf.update(kontrollanruf_params)
      render action: 'save_success'
    else
      render action: 'save_error'
    end
  end

  def destroy
    @kontrollanruf.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    def prepare_kontrollanrufs_json
      @kontrollanrufs = Kontrollanruf.where(:wachbuch_eintrag_id => params[:wb_id])
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_kontrollanruf
      @kontrollanruf = Kontrollanruf.find(params[:id])
    end

    def kontrollanruf_params
      params.require(:kontrollanruf).permit(:wachbuch_eintrag_id, :uhrzeit, :bemerkung)
    end

end
