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

  def test_should_allow_signup
    assert_difference 'Person.count' do
      create_person
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Person.count' do
      create_person(:login => nil)
      assert assigns(:person).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Person.count' do
      create_person(:password => nil)
      assert assigns(:person).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Person.count' do
      create_person(:password_confirmation => nil)
      assert assigns(:person).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Person.count' do
      create_person(:email => nil)
      assert assigns(:person).errors.on(:email)
      assert_response :success
    end
  end
  

  

  protected
    def create_person(options = {})
      post :create, :person => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
