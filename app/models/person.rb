require 'digest/sha1'

class Person < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_format_of       :name,     :with => RE_NAME_OK,  :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD

  attr_accessible :email, :name, :password, :password_confirmation

  class << self
    def authenticate(email, password)
      u = find_by_email(email) # need to get the salt
      u && u.authenticated?(password) ? u : nil
    end
    
    def find_by_valid_password_reset_code(code)
      u = find_by_password_reset_code(code)
      u.password_reset_code_expires.after?(Time.now) ? u : nil
    end
  end
  
  def create_password_reset_code
    self[:password_reset_code]         = self.class.make_token
    self[:password_reset_code_expires] = 1.week.from_now
    save(false)
  end
end
