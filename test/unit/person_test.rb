require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < Test::Unit::TestCase
  def setup
    @person = people(:james)
  end
  
  def test_should_create_person
    assert_difference 'Person.count' do
      person = create_person
      assert !person.new_record?, "#{person.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'Person.count' do
      u = create_person(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'Person.count' do
      u = create_person(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'Person.count' do
      u = create_person(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'Person.count' do
      u = create_person(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    people(:james).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal people(:james), Person.authenticate('james', 'new password')
  end

  def test_should_not_rehash_password
    people(:james).update_attributes(:login => 'james2')
    assert_equal people(:james), Person.authenticate('james2', 'monkey')
  end

  def test_should_authenticate_person
    assert_equal people(:james), Person.authenticate('james', 'monkey')
  end

  def test_should_set_remember_token
    people(:james).remember_me
    assert_not_nil people(:james).remember_token
    assert_not_nil people(:james).remember_token_expires_at
  end

  def test_should_unset_remember_token
    people(:james).remember_me
    assert_not_nil people(:james).remember_token
    people(:james).forget_me
    assert_nil people(:james).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    people(:james).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil people(:james).remember_token
    assert_not_nil people(:james).remember_token_expires_at
    assert people(:james).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    people(:james).remember_me_until time
    assert_not_nil people(:james).remember_token
    assert_not_nil people(:james).remember_token_expires_at
    assert_equal people(:james).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    people(:james).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil people(:james).remember_token
    assert_not_nil people(:james).remember_token_expires_at
    assert people(:james).remember_token_expires_at.between?(before, after)
  end

protected
  def create_person(options = {})
    record = Person.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.save
    record
  end
end
