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
    def logged_in_as(person)
      context "logged in as #{person}" do
        setup do
          # Restful Auth's login_as test helper
          login_as person
        end
        
        yield
      end
    end
    
    def on_subdomain(sd)
      context "on subdomain #{sd}" do
        setup do
          subdomain sd
        end
    
        yield
      end
    end
    
    def not_logged_in
      context "not logged in" do
        setup do
          # Restful Auth's login_as test helper
          login_as nil
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

Test::Unit::TestCase.send :include, SecurityMacros
