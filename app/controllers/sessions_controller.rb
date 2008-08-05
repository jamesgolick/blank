# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  def create
    logout_keeping_session!
    person = Person.authenticate(params[:login], params[:password])
    if person
      self.current_person = person
      new_cookie_flag     = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      
      flash[:notice] = "Logged in successfully"
      redirect_back_or_default('/')
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
