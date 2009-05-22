require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  context "" do
    setup do
      @person = Factory(:person)
    end

    context "Logged in" do
      setup do
        login_as @person
      end

      # should_be_restful do |resource|
      #   resource.formats         = [:html]
      #   resource.klass           = Person
      #   resource.actions         = [:edit, :update]
      #   resource.update.redirect = 'account_url'
      # end
    end

    not_logged_in do
      context "on GET to :edit" do
        setup do
          get :edit, :id => @person.id
        end

        should_deny_access
      end

      context "With valid password reset code" do
        setup do
          @person.create_password_reset_code
          get :edit, :password_reset_code => @person.password_reset_code
        end

        should_set_the_flash_to(/reset your password/i)
        should "login as the user who owns the code" do
          assert_equal @person, current_person
        end

        should "clear the password reset code" do
          assert_nil @person.reload.password_reset_code
        end

        should_respond_with :success
        should_render_template :edit
      end

      context "on PUT to :update" do
        setup do
          put :update, :id => @person.id, :person => {}
        end

        should_deny_access
      end
    end
  end
end
