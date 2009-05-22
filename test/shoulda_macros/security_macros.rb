module SecurityMacros
  def self.included(klass)
    klass.class_eval do 
      extend  ClassMethods
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def subdomain(subdomain)
      @request.host = "#{subdomain}.#{HOST}"
    end
  end
  
  module ClassMethods
    def not_logged_in
      context "not logged in" do
        setup do
          # Restful Auth's login_as test helper
          login_as nil
        end
    
        yield
      end
    end
    
    # Asserts that access is denied, meaning the browser knows there's something
    # there, and just needs the proper credentials
    def should_deny_access
      should_respond_with :redirect
      should_redirect_to("the login page") { login_url }
      should_set_the_flash_to(/must be logged in/i)
    end

    # Asserts that the response is a 404.
    # This prevents an attacker from knowing that there's something at this location.
    def should_block_access
      should_respond_with :missing
      should_render_template "404"
      should_not_set_the_flash
    end
  end
end

Test::Unit::TestCase.send :include, SecurityMacros
