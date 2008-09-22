require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < Test::Unit::TestCase
  def self.should_login
    should "log the user in" do
      assert_equal people(:james), current_person
    end
    
    should "redirect" do
      assert_response :redirect
    end
  end
  
  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  context "on POST to :create" do
    setup do
      post :create, :email => 'james@giraffesoft.ca', :password => 'monkey', :remember_me => "0"
    end
    
    should_login
    
    should "not set a remember me token" do
      assert @response.cookies["auth_token"].blank?
    end
  end
  
  context "on POST to :create with remember_me" do
    setup do
      post :create, :email => 'james@giraffesoft.ca', :password => 'monkey', :remember_me => "1"
    end
    
    should_login
    
    should "set a remember me token" do
      assert_not_nil @response.cookies["auth_token"]
    end
  end
  
  context "on POST to create with invalid credentials" do
    setup do
      post :create, :email => 'whatever', :password => 'nothign'
    end

    should_respond_with :success
    should_render_template :new
    should "not log in" do
      assert_nil session[:person_id]      
    end
  end

  context "on get to :destroy" do
    setup do
      @request.cookies["auth_token"] = cookie_for(:james)
      login_as :james
      get :destroy
    end

    should "redirect" do
      assert_response :redirect
    end
    
    should "log the user out" do
      assert_nil session[:person_id]
    end
    
    should "delete the login token" do
      assert @response.cookies["auth_token"].blank?
    end
  end
  
  context "on get to new with cookie" do
    setup do
      people(:james).remember_me
      @request.cookies["auth_token"] = cookie_for(:james)
      get :new
    end

    should "log the user in" do
      assert @controller.send(:logged_in?)
    end
  end
  
  context "on get to new with invalid cookie" do
    setup do
      people(:james).remember_me
      people(:james).update_attribute :remember_token_expires_at, 5.minutes.ago
      @request.cookies["auth_token"] = cookie_for(:james)
      get :new
    end

    should "not log the user in" do
      assert !@controller.send(:logged_in?)
    end
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(person)
      auth_token people(person).remember_token
    end
end
