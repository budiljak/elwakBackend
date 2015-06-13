# encoding: UTF-8
class KontrollgangsController < ApplicationController
  before_action :set_kontrollgang, only: [:show, :edit, :update, :destroy]

  def index
    prepare_kontrollgangs_json
    respond_to do |format|
      format.json
    end
  end

  def new
    @kontrollgang = Kontrollgang.new
    @kontrollgang.wachbuch_eintrag_id = params[:wachbuch_eintrag_id]
    @kontrollgang.uhrzeit = DateTime.now.strftime(FORMAT_UHRZEIT)
    render partial: "form"
  end
  
  def create
    @kontrollgang = Kontrollgang.new(kontrollgang_params)
    if @kontrollgang.save
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
    if @kontrollgang.update(kontrollgang_params)
      render action: 'save_success'
    else
      render action: 'save_error'
    end
  end

  def destroy
    @kontrollgang.destroy
    respond_to do |format|
      format.js { render action: 'delete_success' }
    end
  end

  private
    def prepare_kontrollgangs_json
      @kontrollgangs = Kontrollgang.where(:wachbuch_eintrag_id => params[:wb_id])
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_kontrollgang
      @kontrollgang = Kontrollgang.find(params[:id])
    end

    def kontrollgang_params
      params.require(:kontrollgang).permit(:wachbuch_eintrag_id, :uhrzeit, :bemerkung)
    end

end
