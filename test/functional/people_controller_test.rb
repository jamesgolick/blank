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
  end
end
