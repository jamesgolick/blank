HoptoadNotifier.configure do |config|
  config.api_key = ''
end

RAILS_DEFAULT_LOGGER.warn('Please add a hoptoad key to config/initializers/hoptoad.rb.') if HoptoadNotifier.api_key.blank?
