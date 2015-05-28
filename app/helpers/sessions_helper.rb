module SessionsHelper

  # Logs in the given user.
  def log_in(user, objekt_id)
    session[:benutzer_id] = user.id
    session[:objekt_id] = objekt_id
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= Benutzer.find_by(id: session[:benutzer_id])
  end

  def current_objekt
    @current_objekt ||= Objekt.find_by(id: session[:objekt_id])
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:benutzer_id)
    session.delete(:objekt_id)
    @current_user = nil
  end
end

