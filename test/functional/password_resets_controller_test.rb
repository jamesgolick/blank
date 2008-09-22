require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  context "on GET to :new" do
    setup do
      get :new
    end

    should_render_template :new
    should_respond_with :success
    should_render_a_form
  end
  
  context "on POST to :create with a valid email" do
    setup do
      post :create, :email => people(:james).email
    end

    should_render_template :create
    should_respond_with :success
    should_set_the_flash_to(/email/i)
  end
  
  context "on POST to :create with an invalid email" do
    setup do
      post :create, :email => 'clearly@nouser.bythisemail.com'
    end

    should_render_template :new
    should_respond_with :success
    should_set_the_flash_to(/cannot/i)
  end
end
