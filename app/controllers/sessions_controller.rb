class SessionsController < ApplicationController
  include SessionsHelper
  
  def new
  end

  def update_objekts
    user = Benutzer.find_by(login: params[:session_login].downcase)
    if user && user.authenticate(params[:session_passwort])
      if user.typ == VERWALTER
        @objekts = Objekt.all
      else
        @objekts = Objekt.joins(:objekt_zuordnungs).where('objekt_zuordnungs.benutzer_id' => user.id)
      end
    else
      @objekts = []
    end
    render 'update_objekts.js'
  end

  def create
    login = params[:session][:login]
    objekt_id = params[:session][:objekt_id]
    user = Benutzer.find_by(login: login.downcase)
    if user && user.authenticate(params[:session][:passwort])
      if !objekt_id || objekt_id == "-1"
        flash.now[:danger] = 'Bitte ein Objekt auswählen!'
        render 'new'
      else
        if user.typ != VERWALTER && !ObjektZuordnung.exists?({benutzer_id: user.id,  objekt_id: objekt_id})
          flash.now[:danger] = 'Ungültiges Objekt!'
          render 'new'
        else
          log_in user, objekt_id
          cookies.permanent[:last_login] = login
          cookies.permanent[:last_objekt_id] = objekt_id
          redirect_to main_index_path
        end
      end
    else
      flash.now[:danger] = 'Login / Passwort ungültig!'
      render 'new', locals: {login: login}
    end
  end

  def destroy
    log_out
    respond_to do |format|
      format.html {redirect_to login_path}
      format.js {render js: "window.location.href = '#{login_path}'"}
    end
  end
end
