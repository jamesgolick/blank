require File.dirname(__FILE__) + '/../test_helper'
require 'people_controller'

# Re-raise errors caught by the controller.
class PeopleController; def rescue_action(e) raise e end; end

class PeopleControllerTest < Test::Unit::TestCase
  def setup
    @controller = PeopleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  should_be_restful do |resource|
    resource.formats         = [:html]
    resource.actions         = [:create, :new]
    resource.create.params   = hash_for_person
    resource.create.redirect = 'people_url'
    resource.create.flash    = /thanks/i
  end
end
