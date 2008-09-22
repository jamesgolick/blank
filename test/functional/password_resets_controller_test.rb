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
end
