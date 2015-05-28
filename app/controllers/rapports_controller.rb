# encoding: UTF-8
class RapportsController < ApplicationController

  def index
    prepare_rapports_json
    respond_to do |format|
      format.json
    end
  end

  def create
  end

  def destroy
    @rapport.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    def prepare_rapports_json
      @rapports = Rapport.where(:schicht_id => params[:schicht_id])
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_rapport
      @rapport = Rapport.find(params[:id])
    end

end
