require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase
  def self.should_set_remember_token
    should "set remember_token" do
      assert_not_nil @person.remember_token      
    end
    
    should "set remember_token_expires_at" do
      assert_not_nil @person.remember_token_expires_at      
    end
  end
  
  def setup
    @person = Factory(:person)
  end
  
  should_require_attributes :email
  
  context "With a new person" do
    setup do
      @person = Person.new
    end

    should_require_attributes :password, :password_confirmation
  end

  should "reset password" do
    @person.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal @person, Person.authenticate(@person.email, 'new password')
  end

  should "not rehash password when it's not updated" do
    @person.update_attributes(:email => @person.email)
    assert_equal @person, Person.authenticate(@person.email, 'monkey')
  end

  should "authenticate person with correct username and password" do
    assert_equal @person, Person.authenticate(@person.email, 'monkey')
  end

  context "Remember me" do
    setup do
      @before = 2.week.from_now.utc
      @person.remember_me
      @after  = 2.week.from_now.utc
    end

    should_set_remember_token
    
    should "default to two weeks" do
      assert @person.remember_token_expires_at.between?(@before, @after)
    end
  end

  should "unset remember token when asked to forget me" do
    @person.forget_me
    assert_nil @person.remember_token
  end
  
  context "Remember me for one week" do
    setup do
      @before = 1.week.from_now.utc
      @person.remember_me_for 1.week
      @after  = 1.week.from_now.utc
    end
    
    should_set_remember_token
    
    should "set the remember token to expire a week from now" do
      assert @person.remember_token_expires_at.between?(@before, @after)
    end
  end
  
  context "Remember me until one week" do
    setup do
      @time = 1.week.from_now.utc
      @person.remember_me_until @time
    end

    should_set_remember_token
    
    should "set the token expire one week from now" do
      assert_equal @person.remember_token_expires_at, @time
    end
  end
  
  context "Creating a password reset code" do
    setup do
      @before = 1.week.from_now.utc
      @person.create_password_reset_code
      @after  = 1.week.from_now.utc
    end

    should "create a password reset code for that user" do
      assert_not_nil @person.password_reset_code
    end
    
    should "create an expiry code for that user" do
      assert_not_nil @person.password_reset_code_expires
    end
    
    should "set an expiry for the code of 1 week" do
      assert @person.password_reset_code_expires.between?(@before, @after)
    end
    
    should "send a password reset email" do
      PasswordResetMailer.expects(:deliver_password_reset).with(@person)
      @person.create_password_reset_code
    end
  end
  
  context "Finding a person by password reset code" do
    setup do
      @person.create_password_reset_code
    end

    should "find a person whose code is valid" do
      assert_equal @person, Person.find_by_valid_password_reset_code(@person.password_reset_code)
    end
    
    should "not find a user whose password reset code is expired" do
      @person.update_attribute :password_reset_code_expires, 1.week.ago
      assert_nil Person.find_by_valid_password_reset_code(@person.password_reset_code)
    end
    
    should "not explode if there's no user by that code" do
      assert_nothing_raised {
        Person.find_by_valid_password_reset_code('asdf')
      }
    end
    
    should "not explode if there's a code but no date" do
      @person.update_attribute :password_reset_code_expires, nil

      assert_nothing_raised {
        Person.find_by_valid_password_reset_code(@person.password_reset_code)
      }
    end
  end
  
  context "Expiring a password reset code" do
    setup do
      @person.update_attribute :password_reset_code, 'asdf'
      @person.update_attribute :password_reset_code_expires, 1.week.from_now
      @person.expire_password_reset_code
    end

    should "remove the password reset code" do
      assert_nil @person.password_reset_code
    end
    
    should "remove the password reset code expiry" do
      assert_nil @person.password_reset_code_expires
    end
  end
end
