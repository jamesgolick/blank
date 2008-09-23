require 'action_mailer'
require 'exception_notifiable'
ApplicationController.send :include, ExceptionNotifiable