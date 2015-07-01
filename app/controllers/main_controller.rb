class MainController < ApplicationController
  include SessionsHelper

  before_filter :logged_in_user
  
  def index
    @infos = Info.joins(:info_empfaengers).where("info_empfaengers.benutzer_id = ?", current_user)
  end

  private
  
    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end
end
