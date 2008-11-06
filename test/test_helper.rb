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

  # Setup transaction per test-case
  setup do
    @__transaction = DataMapper::Transaction.new(DataMapper.repository(:default))
    @__transaction.begin
    # FIXME: Should I really be calling #push_transaction like that, or is there a better way?
    DataMapper.repository(:default).adapter.push_transaction(@__transaction)
  end

  # And roll it back at the end
  teardown do
    if @__transaction then
      DataMapper.repository(:default).adapter.pop_transaction
      @__transaction.rollback
      @__transaction = nil
    end
  end

  protected
    def current_person
      Person.find_by_id(session[:person_id])
    end

    def set_mailer_host
      ActionMailer::Base.default_url_options[:host] = 'test.blankapp.com'
    end
end

Dir[File.join(Rails.root, "app", "models", "*")].each {|f| require f}
DataMapper.auto_migrate!
