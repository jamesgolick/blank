require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  not_logged_in do
    context "on GET to :new" do
      setup do
        get :new
      end

      should_respond_with :success
      should_render_template "new"
      should_not_set_the_flash
      should_render_a_form
    end

    context "on POST to :create with invalid attributes" do
      setup do
        post :create, :person => Factory.attributes_for(:person, :password_confirmation => "not the same password")
      end

      should_respond_with :success
      should_render_template "new"
      should_not_set_the_flash
      should_render_a_form
    end

    context "on POST to :create with valid attributes" do
      setup do
        post :create, :person => Factory.attributes_for(:person)
      end

      should_redirect_to("the homepage") { root_url }
      should_set_the_flash_to /thanks/i
      should "authenticate the new person" do
        assert_not_nil session[:person_id]
      end
    end

    context "Signing up with a valid OpenID" do
      setup do
        stub_open_id(true, 'you rock')
        post :signup_with_open_id, :openid_url => 'http://jamesgolick.com', :person => {:email => "james@giraffesoft.ca", :name => "james", :password => "monkey", :password_confirmation => "monkey"}
      end

      should "create a person and associate the OpenID URL with that person" do
        assert_not_nil Person.find_by_open_id_url('http://jamesgolick.com')
      end

      should_redirect_to("the homepage") { root_url }
    end

    context "When signing up with an invalid openid url" do
      setup do
        Person.find_by_open_id_url('http://jamesgolick.com').andand.destroy
        stub_open_id(false, 'you suck')
        post :signup_with_open_id, :openid_url => 'http://jamesgolick.com'
      end

      should_respond_with :success
      should_render_template 'new'

      should_not_change "Person.count"
    end
  end
end
