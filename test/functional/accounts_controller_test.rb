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
