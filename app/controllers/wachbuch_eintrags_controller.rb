# encoding: UTF-8
class WachbuchEintragsController < ApplicationController
  before_action :set_wachbuch_eintrag, only: [:show, :edit, :update]

  def show
    render partial: "form", locals: {readonly: true}
  end

  def edit
    render partial: "form"
  end

  def update
    convert_boolean_param(:wachbuch_eintrag, :ausruestung_vollzaehlig)
    convert_boolean_param(:wachbuch_eintrag, :ausruestung_funktion)
    convert_boolean_param(:wachbuch_eintrag, :schluessel_vollzaehlig)
    if @wachbuch_eintrag.update(wachbuch_eintrag_params)
      render action: 'save_success'
    else
      render action: 'save_error'
    end
  end

  private
    def convert_boolean_param(key1, key2)
      val = params[key1][key2]
      if !val or "on" == val or "" == val
        params[key1][key2] = nil
      end
      
    end

    def set_wachbuch_eintrag
      @wachbuch_eintrag = WachbuchEintrag.find(params[:id])
    end

    def wachbuch_eintrag_params
      params.require(:wachbuch_eintrag).permit(:besonderheiten, :schaeden, :ausruestung_vollzaehlig, :ausruestung_funktion, :schluessel_vollzaehlig, :schluessel_bemerkung)
    end

end
