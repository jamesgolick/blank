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

      should "have good old fashioned way of login in" do
        assert_form people_path, :post do
          assert_text_field     :person, :email
          assert_password_field :person, :password
          assert_password_field :person, :password_confirmation
          assert_submit
        end
      end

      should "have OpenID field for login in" do
        assert_form signup_with_open_id_people_url, :post do
          assert_text_field :openid_url
          assert_submit
        end
      end
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

    context "Signing up with a valid OpenID and no parameters" do
      setup do
        stub_open_id(true, 'you rock')
        post :signup_with_open_id, :openid_url => 'http://jamesgolick.com'
      end

      should "create a person and associate the OpenID URL with that person" do
        assert_not_nil Person.find_by_open_id_url('http://jamesgolick.com')
      end

      should_redirect_to("the homepage") { root_url }
    end

    context "Signing up with a valid OpenID and full parameters" do
      setup do
        stub_open_id(true, 'you rock')
        post :signup_with_open_id, :openid_url => 'http://jamesgolick.com', :person => {:email => "james@giraffesoft.ca", :name => "james", :password => "monkey", :password_confirmation => "monkey"}
      end

      should "create a person and associate the OpenID URL with that person" do
        assert_not_nil Person.find_by_open_id_url('http://jamesgolick.com')
      end

      should_redirect_to("the homepage") { root_url }

      should "set the name" do
        assert_equal "james", assigns(:person).name
      end

      should "set the email" do
        assert_equal "james@giraffesoft.ca", assigns(:person).email
      end

      should "set the password" do
        assert_equal assigns(:person), Person.authenticate("james@giraffesoft.ca", "monkey")
      end
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
