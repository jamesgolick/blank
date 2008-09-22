require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < Test::Unit::TestCase
  def self.should_set_remember_token
    should "set remember_token" do
      assert_not_nil people(:james).remember_token      
    end
    
    should "set remember_token_expires_at" do
      assert_not_nil people(:james).remember_token_expires_at      
    end
  end
  
  def setup
    @person = people(:james)
  end
  
  should_require_attributes :email
  
  context "With a new person" do
    setup do
      @person = Person.new
    end

    should_require_attributes :password, :password_confirmation
  end

  should "reset password" do
    people(:james).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal people(:james), Person.authenticate('james@giraffesoft.ca', 'new password')
  end

  should "not rehash password when it's not updated" do
    people(:james).update_attributes(:email => 'jamesgolick@gmail.com')
    assert_equal people(:james), Person.authenticate('jamesgolick@gmail.com', 'monkey')
  end

  should "authenticate person with correct username and password" do
    assert_equal people(:james), Person.authenticate('james@giraffesoft.ca', 'monkey')
  end

  context "Remember me" do
    setup do
      @before = 2.week.from_now.utc
      people(:james).remember_me
      @after  = 2.week.from_now.utc
    end

    should_set_remember_token
    
    should "default to two weeks" do
      assert people(:james).remember_token_expires_at.between?(@before, @after)
    end
  end

  should "unset remember token when asked to forget me" do
    people(:james).forget_me
    assert_nil people(:james).remember_token
  end
  
  context "Remember me for one week" do
    setup do
      @before = 1.week.from_now.utc
      people(:james).remember_me_for 1.week
      @after  = 1.week.from_now.utc
    end
    
    should_set_remember_token
    
    should "set the remember token to expire a week from now" do
      assert people(:james).remember_token_expires_at.between?(@before, @after)
    end
  end
  
  context "Remember me until one week" do
    setup do
      @time = 1.week.from_now.utc
      people(:james).remember_me_until @time
    end

    should_set_remember_token
    
    should "set the token expire one week from now" do
      assert_equal people(:james).remember_token_expires_at, @time
    end
  end
  
  context "Creating a password reset code" do
    setup do
      @before = 1.week.from_now.utc
      people(:james).create_password_reset_code
      @after  = 1.week.from_now.utc
    end

    should "create a password reset code for that user" do
      assert_not_nil people(:james).password_reset_code
    end
    
    should "create an expiry code for that user" do
      assert_not_nil people(:james).password_reset_code_expires
    end
    
    should "set an expiry for the code of 1 week" do
      assert people(:james).password_reset_code_expires.between?(@before, @after)
    end
  end
  
  context "Finding a person by password reset code" do
    setup do
      people(:james).create_password_reset_code
    end

    should "find a person whose code is valid" do
      assert_equal people(:james), Person.find_by_valid_password_reset_code(people(:james).password_reset_code)
    end
    
    should "not find a user whose password reset code is expired" do
      people(:james).update_attribute :password_reset_code_expires, 1.week.ago
      assert_nil Person.find_by_valid_password_reset_code(people(:james).password_reset_code)
    end
  end
end
