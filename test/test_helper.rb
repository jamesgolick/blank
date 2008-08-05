ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all
  
  include AuthenticatedTestHelper
  extend  TestDataFactory
  
  data_factory :person, :login => 'gob', :email => 'gob@giraffesoft.ca', :password => 'illusions', :password_confirmation => 'illusions'
end
