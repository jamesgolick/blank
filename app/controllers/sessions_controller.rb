# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  def create
    logout_keeping_session!
    person = Person.authenticate(params[:email], params[:password])

    if person
      successful_login(person)
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def create_with_open_id
    logout_keeping_session!

    authenticate_with_open_id do |result, identity_url|
      if result.successful? && person = Person.find_by_open_id_url(identity_url)
        successful_login(person)
      else
        flash[:error] = "Could not log you in as #{identity_url}."
        flash[:error] << " Message: #{result.message}" unless result.successful?

        render :action => 'new'
      end
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default root_url
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:email]}'"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end

  def successful_login(person)
    self.current_person = person
    new_cookie_flag     = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag

    flash[:notice] = "Logged in successfully"
    redirect_back_or_default root_url
  end
end
