class PasswordResetMailer < ActionMailer::Base
  def password_reset(person)
    recipients [person.email]
    from       "App <noreply@blankapp.com>" # TODO: Change "App" to the name of this app, and change blankapp.com to the actual name of this app.
    subject    "Password Reset for App" # TODO: Change "App" to the name of this app.
    body       :person => person
  end
end
