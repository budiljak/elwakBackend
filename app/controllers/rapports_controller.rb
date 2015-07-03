# encoding: UTF-8
class RapportsController < ApplicationController
  include SessionsHelper
  
  before_action :set_rapport, only: [:show, :edit, :update, :destroy]

  def index
    prepare_rapports_json
    respond_to do |format|
      format.json
    end
  end

  def new
    @rapport = Rapport.new
    @rapport.position = (Rapport.where(schicht_id: current_schicht.id).maximum(:position) || 0) + 1
    @rapport.schicht = current_schicht
    @rapport.uhrzeit = DateTime.now.strftime(FORMAT_UHRZEIT)
    render partial: "form"
  end

  def create
    @rapport = Rapport.new(rapport_params)
    @rapport.schicht = current_schicht
    if @rapport.save
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
    if @rapport.update(rapport_params)
      render action: 'save_success'
    else
      render action: 'save_error'
    end
  end

  def destroy
    @rapport.destroy
    respond_to do |format|
      format.js { render action: 'delete_success' }
    end
  end

  def print
    if params[:schicht_id]
      s = Schicht.find(params[:schicht_id])
      @rapporte = s.rapports
    elsif params[:rapport_id]
      @rapporte = [Rapport.find(params[:rapport_id])]
    end

    respond_to do |format|
      format.js
      format.pdf do
        pdf = RapportePdf.new(@rapporte)
        filename = (@rapporte.length > 1)?"rapporte.pdf":"rapport.pdf"
        send_data pdf.render, filename: filename, type: 'application/pdf'
      end
    end
  end
    
      

  private
    def prepare_rapports_json
      @rapports = Rapport.where(:schicht_id => params[:schicht_id])
      if current_schicht && params[:schicht_id] == current_schicht.id.to_s
        @rapports.unshift(Rapport.new)
      end
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_rapport
      @rapport = Rapport.find(params[:id])
    end

    def rapport_params
      params.require(:rapport).permit(:schicht_id, :position, :beschreibung, :ort, :uhrzeit, :massnahmen)
    end

end
