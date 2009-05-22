ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  setup :set_mailer_host

  include AuthenticatedTestHelper
  
  protected
    def current_person
      Person.find_by_id(session[:person_id])
    end
    
    def set_mailer_host
      ActionMailer::Base.default_url_options[:host] = 'test.blankapp.com'
    end

    def stub_open_id(success, message, url = 'http://jamesgolick.com')
      @controller.stubs(:authenticate_with_open_id).yields(stub(:successful? => success, :message => message), url)
    end
end
