module AuthenticatedTestHelper
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  # Sets the current person in the session from the person fixtures.
  def login_as(person)
    @request.session[:person_id] = person ? people(person).id : nil
  end

  def authorize_as(person)
    @request.env["HTTP_AUTHORIZATION"] = person ? ActionController::HttpAuthentication::Basic.encode_credentials(people(person).login, 'monkey') : nil
  end
  
  module ClassMethods
    def logged_in_as(person)
      context "Logged in as #{person}" do
        setup do
          login_as(person)
        end

        yield
      end
    end
    
    def not_logged_in
      context "Not logged in" do
        setup do
          login_as(nil)
        end

        yield
      end
    end
    
    def should_deny_access
      should_respond_with :redirect
      should_redirect_to  'login_url'
      should_set_the_flash_to(/must be logged in/i)
    end
  end
end
