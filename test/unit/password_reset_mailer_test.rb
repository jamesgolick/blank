require File.dirname(__FILE__)+'/../test_helper'

class PasswordResetMailerTest < ActionMailer::TestCase
  context "The password reset mailer" do
    setup do
      people(:james).create_password_reset_code
      PasswordResetMailer.deliver_password_reset(people(:james))
      @sent = ActionMailer::Base.deliveries.first
    end

    should "send to that user" do
      assert_equal [people(:james).email], @sent.to
    end
    
    should "have the URL of the password reset code in it" do
      assert_match people(:james).password_reset_code, @sent.body
    end
  end
end
