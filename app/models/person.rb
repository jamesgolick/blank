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

  validates_uniqueness_of   :open_id_url, :if => :open_id_url?
  validate                  :validate_open_id_url_authentication, :if => :open_id_url?

  attr_accessible :email, :name, :password, :password_confirmation, :open_id_url
  attr_accessor :open_id_url_authenticated, :open_id_url_message

  class << self
    def authenticate(email, password)
      u = find_by_email(email) # need to get the salt
      u && u.authenticated?(password) ? u : nil
    end

    def find_by_valid_password_reset_code(code)
      u = find_by_password_reset_code(code)
      u && u.password_reset_code_expires && u.password_reset_code_expires.after?(Time.now) ? u : nil
    end
  end

  def create_password_reset_code
    self[:password_reset_code]         = self.class.make_token
    self[:password_reset_code_expires] = 1.week.from_now
    save(false)

    PasswordResetMailer.deliver_password_reset(self)
  end

  def expire_password_reset_code
    self[:password_reset_code]         = nil
    self[:password_reset_code_expires] = nil
    save(false)
  end

  def open_id_url_authenticated?
    !!open_id_url_authenticated
  end

  protected
  def validate_open_id_url_authentication
    errors.add(:open_id_url, open_id_url_message) if new_record? && !open_id_url_authenticated?
  end
end
