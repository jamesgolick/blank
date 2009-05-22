require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def self.should_login
    should "log the user in" do
      assert_equal @person, current_person
    end

    should "redirect" do
      assert_response :redirect
    end
  end

  context "Given an existing person" do
    setup do
      @person = Factory(:person)
    end

    context "on POST to :create with correct credentials" do
      setup do
        post :create, :email => @person.email, :password => 'monkey', :remember_me => "0"
      end

      should_login

      should "not set a remember me token" do
        assert @response.cookies["auth_token"].blank?
      end
    end

    context "on POST to :create with correct credentials and remember_me" do
      setup do
        post :create, :email => @person.email, :password => 'monkey', :remember_me => "1"
      end

      should_login

      should "set a remember me token" do
        assert_not_nil @response.cookies["auth_token"]
      end
    end

    context "on get to :destroy" do
      setup do
        @request.cookies["auth_token"] = cookie_for(@person)
        login_as @person
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
  end
  
  context "on POST to create with invalid credentials" do
    setup do
      post :create, :email => 'whatever', :password => 'nothign'
    end

    should_respond_with :success
    should_render_template :new
    should_set_the_flash_to /Couldn't log you in as 'whatever'/i
    should "not log in" do
      assert_nil session[:person_id]      
    end
  end
  
  context "Given a remembered person" do
    setup do
      @person = Factory(:remembered_person)
      @request.cookies["auth_token"] = cookie_for(@person)
    end

    context "on get to new with cookie" do
      setup do
        get :new
      end

      should "log the user in" do
        assert @controller.send(:logged_in?)
      end
    end

    context "on get to new with a bad cookie" do
      setup do
        @person.update_attribute(:remember_token, @person.remember_token.succ)
        get :new
      end

      should "not log the user in" do
        assert !@controller.send(:logged_in?)
      end
    end

    context "on get to new with an expired cookie" do
      setup do
        @person.update_attribute(:remember_token_expires_at, 5.minutes.ago)
        get :new
      end

      should "not log the user in" do
        assert !@controller.send(:logged_in?)
      end
    end
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(person)
      auth_token person.remember_token
    end
end
