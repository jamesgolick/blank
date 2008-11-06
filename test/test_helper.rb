ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

# Make double-sure the RAILS_ENV is set to test,
# so fixtures are loaded to the right database
silence_warnings { RAILS_ENV = "test" }

require 'test/unit'
require 'active_support/test_case'
require 'action_controller/test_case'
require 'action_controller/test_process'
require 'action_controller/integration'
require 'action_mailer/test_case' if defined?(ActionMailer)

class Test::Unit::TestCase
  setup    :set_mailer_host

  include AuthenticatedTestHelper
  extend  TestDataFactory
  
  data_factory :person, :email => 'gob@giraffesoft.ca', :password => 'illusions', :password_confirmation => 'illusions'
  
  protected
    def current_person
      Person.find_by_id(session[:person_id])
    end
    
    def set_mailer_host
      ActionMailer::Base.default_url_options[:host] = 'test.blankapp.com'
    end
end
