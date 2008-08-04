require File.dirname(__FILE__) + '/../test_helper'
require '<%= file_name %>_mailer'

class <%= class_name %>MailerTest < Test::Unit::TestCase
  fixtures :<%= table_name %>
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionController::UrlWriter.default_url_options[:host] = 'test'
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end

  def test_activation
    assert_difference ActionMailer::Base.deliveries do 
      response = <%= class_name %>Mailer.create_activation(<%= table_name %>(:quentin))
      assert response.subject =~ /Your account has been activated\!/
      assert response.body    =~ /http:\/\/test\/login/
    end
  end
  
  def test_signup_notification
    <%= table_name %>(:quentin).activation_code = '123'
    assert_difference ActionMailer::Base.deliveries do 
      email = <%= class_name %>Mailer.create_signup_notification(<%= table_name %>(:quentin))
      assert email.subject =~ /Please activate your new account/
<% if options[:include_activation] -%>
      assert email.body    =~ /http:\/\/test\/activate\/123/
<% else -%>
      assert email.body    =~ /http:\/\/test\/login
<% end -%>
      assert_equal "arealemail@example.com", email.from.first
      assert_match "[A real origin]",   email.subject
    end
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/<%= file_name %>_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
