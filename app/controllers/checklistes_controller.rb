# encoding: UTF-8
class ChecklistesController < ApplicationController
  include SessionsHelper
  
  before_action :set_checkliste, only: [:show, :edit, :update, :destroy]

  def index
    prepare_checklistes_json
    respond_to do |format|
      format.json
    end
  end

  def new
    if (params[:vorlage_id])
      @checkliste = Checkliste.new
      @checkliste.position = (Checkliste.where(schicht_id: current_schicht.id).maximum(:position) || 0) + 1
      @checkliste.schicht = current_schicht
      cv = ChecklistenVorlage.find(params[:vorlage_id])
      @checkliste.checklisten_vorlage = cv
      cv.checklisten_eintrags.each do |ce|
        @checkliste.checklisten_werts.push(ChecklistenWert.new(checklisten_eintrag: ce))
      end
      @checkliste.uhrzeit = DateTime.now.strftime(FORMAT_UHRZEIT)
      render partial: 'form'
    else
      @vorlages = ChecklistenVorlage.where(objekt_id: current_objekt.id).where(inaktiv: false)
      render aciton: 'new', layout: false
    end
  end

  def create
    @checkliste = Checkliste.new(checkliste_params)
    @checkliste.schicht = current_schicht
    puts params[:vorlage_id]
    @checkliste.checklisten_vorlage = ChecklistenVorlage.find(params[:vorlage_id])
    if @checkliste.save
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
    if @checkliste.update(checkliste_params)
      render action: 'save_success'
    else
      render action: 'save_error'
    end
  end

  def destroy
    @checkliste.destroy
    respond_to do |format|
      format.js { render action: 'delete_success' }
    end
  end

  private
    def prepare_checklistes_json
      @checklistes = Checkliste.where(:schicht_id => params[:schicht_id])
      if current_schicht && current_schicht.id.to_s == params[:schicht_id]
        @checklistes.unshift(Checkliste.new)
      end
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_checkliste
      @checkliste = Checkliste.find(params[:id])
      logger.debug(@checkliste.checklisten_werts.count)
    end

    def checkliste_params
      params.require(:checkliste).permit(:uhrzeit, :position, checklisten_werts_attributes: [:id, :checklisten_eintrag_id, :inhalt])
    end

end
