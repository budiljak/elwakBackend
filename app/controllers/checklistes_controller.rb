# encoding: UTF-8
class ChecklistesController < ApplicationController

  def index
    prepare_checklistes_json
    respond_to do |format|
      format.json
    end
  end

  def create
  end

  def destroy
    @checkliste.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    def prepare_checklistes_json
      @checklistes = Checkliste.where(:schicht_id => params[:schicht_id])
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_checkliste
      @checkliste = Checkliste.find(params[:id])
    end

end
