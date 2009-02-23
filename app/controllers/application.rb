class ApplicationController < ActionController::Base
  include AuthenticatedSystem, HoptoadNotifier::Catcher

  helper :all
  before_filter :configure_mailers
  
  filter_parameter_logging :password
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def home
    render :text => "Welcome! (in application.rb / home)"
  end
  
  protected
    def configure_mailers
      PasswordResetMailer.configure(request)
    end
end
