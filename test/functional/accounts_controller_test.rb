require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  def setup
    @person = people(:james)
  end
  
  logged_in_as :james do
    should_be_restful do |resource|
      resource.formats         = [:html]
      resource.klass           = Person
      resource.actions         = [:edit, :update]
      resource.update.redirect = 'edit_account_url'
    end
  end
  
  not_logged_in do
    context "With valid password reset code" do
      setup do
        people(:james).create_password_reset_code
        get :edit, :password_reset_code => people(:james).password_reset_code
      end

      should_set_the_flash_to(/reset your password/i)
      should "login as the user who owns the code" do
        assert_equal people(:james), current_person
      end
      
      should "clear the password reset code" do
        assert_nil people(:james).reload.password_reset_code
      end
      
      should_respond_with :success
      should_render_template :edit
    end
    
    context "on GET to :edit" do
      setup do
        get :edit
      end

      should_deny_access
    end
    
    context "on POST to :update" do
      setup do
        post :update, :person => {}
      end

      should_deny_access
    end
  end
end
