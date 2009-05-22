require 'test_helper'

class PasswordResetMailerTest < ActionMailer::TestCase
  context "The password reset mailer" do
    setup do
      @person = Factory(:person)
      @person.create_password_reset_code
      PasswordResetMailer.deliver_password_reset(@person)
      @sent = ActionMailer::Base.deliveries.first
    end

    should "send to that user" do
      assert_equal [@person.email], @sent.to
    end
    
    should "have the URL of the password reset code in it" do
      assert_match @person.password_reset_code, @sent.body
    end
  end
end
